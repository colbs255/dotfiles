#!/usr/bin/env bash
# Popup command bound to prefix+a (see keys.command in config.toml):
# picks a workspace, creates a worktree in it, and starts a named agent
# there with a prompt.
#
# Only the interactive input-gathering runs in the popup. The worktree
# create + agent start + prompt submission (which can take a while) runs
# detached in the background so the popup closes immediately after you
# submit the prompt instead of blocking the whole session until it's done.
# Failures are reported via a herdr notification instead of on screen.
set -euo pipefail

fail() {
    echo "$1" >&2
    read -rp "press enter to close..." _
    exit 1
}

if ! workspaces_json=$(herdr workspace list 2>&1); then
    fail "failed to list workspaces: $workspaces_json"
fi

workspace_label=$(jq -r '.result.workspaces[] | (.worktree.repo_name // .label)' <<<"$workspaces_json" |
    sort -u | fzf --prompt="workspace> ") || fail "no workspace selected"

read -rp "agent name: " name
[ -n "$name" ] || fail "name required"

echo "prompt (end with ctrl-d):"
prompt=$(cat)
[ -n "$prompt" ] || fail "prompt required"

workspace_id=$(jq -r --arg q "$workspace_label" '
    [.result.workspaces[] | select((.worktree.repo_name // .label) == $q)]
    | sort_by(.worktree.is_linked_worktree // false)
    | .[0].workspace_id // empty
' <<<"$workspaces_json")
[ -n "$workspace_id" ] || fail "could not resolve workspace id for '$workspace_label'"

log=$(mktemp -t herdr-spawn-agent.XXXXXX.log)

setsid nohup bash -c '
    set -euo pipefail
    workspace_id=$1 name=$2 prompt=$3

    notify_fail() {
        herdr notification show "spawn-agent failed" --body "$1" >/dev/null 2>&1 || true
        exit 1
    }

    if ! create_result=$(herdr worktree create --workspace "$workspace_id" --no-focus 2>&1); then
        notify_fail "worktree create: $create_result"
    fi

    pane_id=$(jq -r ".result.root_pane.pane_id // empty" <<<"$create_result")
    [ -n "$pane_id" ] || notify_fail "no pane id in worktree create response"

    if ! start_result=$(herdr agent start "$name" --kind claude --pane "$pane_id" 2>&1); then
        notify_fail "agent start: $start_result"
    fi

    if ! prompt_result=$(herdr agent prompt "$name" "$prompt" --wait 2>&1); then
        notify_fail "agent prompt: $prompt_result"
    fi

    herdr notification show "spawn-agent done" --body "$name is ready" >/dev/null 2>&1 || true
' _ "$workspace_id" "$name" "$prompt" >"$log" 2>&1 </dev/null &
disown

echo "spawning '$name' in the background (log: $log)"
sleep 1

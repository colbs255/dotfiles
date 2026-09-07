#!/usr/bin/env bash
# Popup command bound to prefix+a (see keys.command in config.toml):
# picks a workspace, creates a worktree in it, and starts a named agent
# there with a prompt.
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

echo "creating worktree for $workspace_label..."
if ! create_result=$(herdr worktree create --workspace "$workspace_id" --no-focus 2>&1); then
    fail "worktree create failed: $create_result"
fi

pane_id=$(jq -r '.result.root_pane.pane_id // empty' <<<"$create_result")
[ -n "$pane_id" ] || fail "no pane id in worktree create response: $create_result"

echo "starting agent $name..."
if ! start_result=$(herdr agent start "$name" --kind claude --pane "$pane_id" 2>&1); then
    fail "failed to start agent: $start_result"
fi

echo "sending prompt..."
if ! prompt_result=$(herdr agent prompt "$name" "$prompt" --wait 2>&1); then
    fail "failed to submit prompt: $prompt_result"
fi

echo "done."
read -rp "press enter to close..." _

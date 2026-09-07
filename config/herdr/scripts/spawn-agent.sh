#!/usr/bin/env bash
# Popup command bound to prefix+d (see keys.command in config.toml):
# picks a workspace, creates a worktree in it, and starts a named agent
# there with a prompt.
#
# Only the interactive input-gathering runs in the popup. The worktree
# create + agent start + prompt submission (which can take a while) runs
# as a transient systemd --user unit so the popup closes immediately after
# you submit the prompt instead of blocking the whole session until it's
# done. This must be a real systemd unit, not a backgrounded/setsid/disowned
# job: herdr appears to reap a popup command's whole descendant process
# tree on close (probably by walking /proc parent links), which kills a
# merely-backgrounded job even in its own session. Handing it to systemd
# fully detaches it from herdr's process tree. Failures are reported via a
# herdr notification instead of on screen.
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

input_file=$(mktemp -t herdr-spawn-agent-input.XXXXXX)
trap 'rm -f "$input_file"' EXIT

cat >"$input_file" <<'EOF'
# Type the agent name on the line below, leave the === delimiter line
# alone, then write the prompt underneath it (multiple lines are fine).
agent-name

===
Describe what you want the agent to do here.
EOF

before_hash=$(md5sum "$input_file" | cut -d' ' -f1)
"${VISUAL:-${EDITOR:-vi}}" "$input_file" || fail "editor exited with an error"
after_hash=$(md5sum "$input_file" | cut -d' ' -f1)
[ "$before_hash" != "$after_hash" ] || fail "no changes made, aborting"

delimiter_line=$(grep -n '^===$' "$input_file" | head -1 | cut -d: -f1)
[ -n "$delimiter_line" ] || fail "could not find the '===' delimiter line, don't remove it"

name=$(grep -vE '^\s*#' "$input_file" | awk 'NF{print; exit}')
[ -n "$name" ] || fail "name required"

prompt=$(tail -n +"$((delimiter_line + 1))" "$input_file")
[ -n "${prompt// /}" ] || fail "prompt required"

workspace_id=$(jq -r --arg q "$workspace_label" '
    [.result.workspaces[] | select((.worktree.repo_name // .label) == $q)]
    | sort_by(.worktree.is_linked_worktree // false)
    | .[0].workspace_id // empty
' <<<"$workspaces_json")
[ -n "$workspace_id" ] || fail "could not resolve workspace id for '$workspace_label'"

worktree_name="${name}-${RANDOM}"

log=$(mktemp -t herdr-spawn-agent.XXXXXX.log)

# shellcheck disable=SC2016 # single-quoted on purpose: $1.. resolve in the inner bash -c, not here
systemd-run --user --collect --unit="herdr-spawn-agent-$$-$RANDOM" \
    --setenv=PATH="$PATH" \
    --setenv=HERDR_SOCKET_PATH="${HERDR_SOCKET_PATH:-}" \
    -- bash -c '
    exec >"$1" 2>&1
    set -euo pipefail
    workspace_id=$2 name=$3 prompt=$4 worktree_name=$5

    notify_fail() {
        echo "$1"
        herdr notification show "spawn-agent failed" --body "$1" >/dev/null 2>&1 || true
        exit 1
    }

    if ! create_result=$(herdr worktree create --workspace "$workspace_id" --branch "$worktree_name" --label "$worktree_name" --no-focus 2>&1); then
        notify_fail "worktree create: $create_result"
    fi
    echo "worktree create: $create_result"

    pane_id=$(jq -r ".result.root_pane.pane_id // empty" <<<"$create_result")
    [ -n "$pane_id" ] || notify_fail "no pane id in worktree create response"

    if ! start_result=$(herdr agent start "$name" --kind claude --pane "$pane_id" -- --dangerously-skip-permissions 2>&1); then
        notify_fail "agent start: $start_result"
    fi
    echo "agent start: $start_result"

    if ! prompt_result=$(herdr agent prompt "$name" "$prompt" --wait 2>&1); then
        notify_fail "agent prompt: $prompt_result"
    fi
    echo "agent prompt: $prompt_result"

    herdr notification show "spawn-agent done" --body "$name is ready" >/dev/null 2>&1 || true
' _ "$log" "$workspace_id" "$name" "$prompt" "$worktree_name"

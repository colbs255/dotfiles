#!/usr/bin/env bash
# Popup command bound to prefix+d (see keys.command in config.toml):
# picks a workspace, creates a worktree in it, and starts a named agent
# there with a prompt. The agent/worktree name is derived automatically
# from the prompt (via a quick haiku call) rather than typed by hand.
#
# Only the interactive input-gathering runs in the popup. The name
# generation + worktree create + agent start + prompt submission (which can
# take a while) runs as a transient systemd --user unit so the popup closes
# immediately after you submit the prompt instead of blocking the whole
# session until it's done. This must be a real systemd unit, not a
# backgrounded/setsid/disowned job: herdr appears to reap a popup command's
# whole descendant process tree on close (probably by walking /proc parent
# links), which kills a merely-backgrounded job even in its own session.
# Handing it to systemd fully detaches it from herdr's process tree.
# Failures are reported via a herdr notification instead of on screen.
set -euo pipefail

fail() {
    echo "$1" >&2
    read -rp "press enter to close..." _
    exit 1
}

# List open workspaces and let the user fuzzy-pick one by repo/label.
if ! workspaces_json=$(herdr workspace list 2>&1); then
    fail "failed to list workspaces: $workspaces_json"
fi

workspace_label=$(jq -r '.result.workspaces[] | (.worktree.repo_name // .label)' <<<"$workspaces_json" |
    sort -u | fzf --prompt="workspace> ") || fail "no workspace selected"

# Open $EDITOR on a template so the user can type the task description.
input_file=$(mktemp -t herdr-spawn-agent-input.XXXXXX)
trap 'rm -f "$input_file"' EXIT

cat >"$input_file" <<'EOF'
# Describe what you want the agent to do below (multiple lines are fine).
# The agent name and worktree will be generated automatically from this.
EOF

before_hash=$(md5sum "$input_file" | cut -d' ' -f1)
"${VISUAL:-${EDITOR:-vi}}" "$input_file" || fail "editor exited with an error"
after_hash=$(md5sum "$input_file" | cut -d' ' -f1)
[ "$before_hash" != "$after_hash" ] || fail "no changes made, aborting"

prompt=$(grep -vE '^\s*#' "$input_file")
[ -n "${prompt// /}" ] || fail "prompt required"

# Map the human-readable label back to herdr's internal workspace id.
workspace_id=$(jq -r --arg q "$workspace_label" '
    [.result.workspaces[] | select((.worktree.repo_name // .label) == $q)]
    | sort_by(.worktree.is_linked_worktree // false)
    | .[0].workspace_id // empty
' <<<"$workspaces_json")
[ -n "$workspace_id" ] || fail "could not resolve workspace id for '$workspace_label'"

log=$(mktemp -t herdr-spawn-agent.XXXXXX.log)

# Hand the prompt off via a file (rather than passed as an argv word) so that a prompt
# containing literal $-sequences can't be mangled by systemd-run's own
# variable substitution on ExecStart argv (see note below).
prompt_file=$(mktemp -t herdr-spawn-agent-prompt.XXXXXX)
printf '%s' "$prompt" >"$prompt_file"

# The inner logic lives in its own file rather than a `bash -c '...'` string:
# systemd-run does its own ${FOO}-style variable substitution on ExecStart
# argv words (looked up in the unit's environment), so any ${name}/${RANDOM}
# style reference written inline here would silently get replaced with an
# empty string before bash ever saw it. A file path on the command line has
# no such sequences for systemd to mangle, and the script's own $ references
# are only interpreted once bash reads it from disk.
runner=$(mktemp -t herdr-spawn-agent-runner.XXXXXX.sh)

cat >"$runner" <<'EOF'
#!/usr/bin/env bash
exec >"$1" 2>&1
set -euo pipefail
workspace_id=$2
prompt=$(cat "$3")
rm -f "$3"

notify_fail() {
    echo "$1"
    herdr notification show "spawn-agent failed" --body "$1" >/dev/null 2>&1 || true
    exit 1
}

# Ask a fast/cheap model for a short slug summarizing the task, and
# sanitize it to lowercase-kebab-case; fall back to a timestamp if that fails.
name_raw=$(claude -p --model haiku "Summarize the following task as a short slug: 2 to 4 lowercase words separated by hyphens, no punctuation, no quotes, no other text in your response.

Task:
$prompt" 2>/dev/null) || name_raw=""
name=$(printf "%s" "$name_raw" | tr "[:upper:]" "[:lower:]" | tr -c "a-z0-9" "-" | sed -E "s/-+/-/g; s/^-+//; s/-+$//" | cut -c1-40)
[ -n "$name" ] || name="task-$(date +%s)"
echo "generated name: $name"

worktree_name="${name}-${RANDOM}"

# Create the git worktree/branch for this task.
if ! create_result=$(herdr worktree create --workspace "$workspace_id" --branch "$worktree_name" --label "$worktree_name" --no-focus 2>&1); then
    notify_fail "worktree create: $create_result"
fi
echo "worktree create: $create_result"

pane_id=$(jq -r ".result.root_pane.pane_id // empty" <<<"$create_result")
[ -n "$pane_id" ] || notify_fail "no pane id in worktree create response"

# Start a named Claude agent in that worktree's pane.
if ! start_result=$(herdr agent start "$name" --kind claude --pane "$pane_id" -- --dangerously-skip-permissions 2>&1); then
    notify_fail "agent start: $start_result"
fi
echo "agent start: $start_result"

# Submit the task prompt to it and wait for it to be delivered.
if ! prompt_result=$(herdr agent prompt "$name" "$prompt" --wait 2>&1); then
    notify_fail "agent prompt: $prompt_result"
fi
echo "agent prompt: $prompt_result"

herdr notification show "spawn-agent done" --body "$name is ready" >/dev/null 2>&1 || true
rm -f "$0"
EOF
chmod +x "$runner"

systemd-run --user --collect --unit="herdr-spawn-agent-$$-$RANDOM" \
    --setenv=PATH="$PATH" \
    --setenv=HERDR_SOCKET_PATH="${HERDR_SOCKET_PATH:-}" \
    -- bash "$runner" "$log" "$workspace_id" "$prompt_file"

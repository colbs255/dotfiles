#!/usr/bin/env bash
# Background half of prefix+d (see spawn-agent.sh). Runs in a scratch herdr
# tab created by spawn-agent.sh: generates a short name for the task,
# creates a worktree, starts a named Claude agent in it, and submits the
# prompt. Failures are reported via a herdr notification since nobody is
# watching this pane. Closes its own scratch tab when done either way.
set -euo pipefail

workspace_id=$1
prompt=$(cat "$2")
rm -f "$2"
scratch_tab_id=$3

notify_fail() {
    echo "$1"
    herdr notification show "spawn-agent failed" --body "$1" >/dev/null 2>&1 || true
    herdr tab close "$scratch_tab_id" >/dev/null 2>&1 || true
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
herdr tab close "$scratch_tab_id" >/dev/null 2>&1 || true

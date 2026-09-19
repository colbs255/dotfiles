#!/usr/bin/env bash
# Popup command bound to prefix+d (see keys.command in config.toml):
# picks a workspace, creates a worktree in it, and starts a named agent
# there with a prompt. The agent/worktree name is derived automatically
# from the prompt (via a quick haiku call) rather than typed by hand.
#
# Only the interactive input-gathering runs in the popup. The name
# generation + worktree create + agent start + prompt submission (which can
# take a while) runs in a separate background herdr tab instead of inline,
# so the popup closes immediately after you submit the prompt instead of
# blocking the whole session until it's done. This doesn't need a
# detachment trick like a transient systemd unit: a pane created via
# `herdr tab create` is spawned and owned by the herdr server itself, not
# by this popup script, so it was never in the popup's process tree to
# begin with and survives the popup closing naturally. The runner closes
# its own scratch tab when it's done. Failures are reported via a herdr
# notification instead of on screen.
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
# Markdown extension so the editor applies markdown highlighting/wrapping to
# the prompt. The template is just a plain placeholder line the user clears
# and replaces, so the whole file content becomes the prompt verbatim.
input_file=$(mktemp --suffix=.md -t herdr-spawn-agent-input.XXXXXX)
trap 'rm -f "$input_file"' EXIT

echo "Clear this line and enter your prompt" >"$input_file"

before_hash=$(md5sum "$input_file" | cut -d' ' -f1)
"${VISUAL:-${EDITOR:-vi}}" "$input_file" || fail "editor exited with an error"
after_hash=$(md5sum "$input_file" | cut -d' ' -f1)
[ "$before_hash" != "$after_hash" ] || fail "no changes made, aborting"

prompt=$(<"$input_file")
[ -n "${prompt// /}" ] || fail "prompt required"

# Map the human-readable label back to herdr's internal workspace id.
workspace_id=$(jq -r --arg q "$workspace_label" '
    [.result.workspaces[] | select((.worktree.repo_name // .label) == $q)]
    | sort_by(.worktree.is_linked_worktree // false)
    | .[0].workspace_id // empty
' <<<"$workspaces_json")
[ -n "$workspace_id" ] || fail "could not resolve workspace id for '$workspace_label'"

# Hand the prompt off via a file (rather than passed as an argv word) so that a prompt
# containing literal $-sequences can't be mangled by the shell parsing the `pane run`
# command text sent into the scratch pane below.
prompt_file=$(mktemp -t herdr-spawn-agent-prompt.XXXXXX)
printf '%s' "$prompt" >"$prompt_file"

# The background half of the workflow lives in its own deployed script
# (spawn-agent-runner.sh, next to this one) rather than inline, so it gets
# normal shellcheck coverage and doesn't need regenerating into a temp file
# on every run.
runner="$(dirname "$0")/spawn-agent-runner.sh"

# Open a background tab to run the setup logic in. Its pane belongs to the
# herdr server, not to this popup process, so it keeps running (and its
# output stays inspectable via `herdr pane read`) after the popup closes.
if ! tab_result=$(herdr tab create --workspace "$workspace_id" --label "spawn-agent" --no-focus 2>&1); then
    fail "tab create: $tab_result"
fi

scratch_pane_id=$(jq -r '.result.root_pane.pane_id // empty' <<<"$tab_result")
scratch_tab_id=$(jq -r '.result.tab.tab_id // empty' <<<"$tab_result")
[ -n "$scratch_pane_id" ] || fail "no pane id in tab create response"
[ -n "$scratch_tab_id" ] || fail "no tab id in tab create response"

if ! run_result=$(herdr pane run "$scratch_pane_id" "bash '$runner' '$workspace_id' '$prompt_file' '$scratch_tab_id'" 2>&1); then
    fail "pane run: $run_result"
fi

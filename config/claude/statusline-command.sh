#!/usr/bin/env bash
# Minimal Claude Code status line:
# model | folder | git-branch | tokens | context%

set -euo pipefail

input=$(cat)

model=$(printf '%s' "$input" | jq -r '.model.display_name // "?"')
cwd=$(printf '%s' "$input" | jq -r '.workspace.current_dir // .cwd // "."')
folder=$(basename "$cwd")

branch=""
if git -C "$cwd" --no-optional-locks rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  branch=$(git -C "$cwd" --no-optional-locks branch --show-current 2>/dev/null || true)
fi

in_tok=$(printf '%s' "$input" | jq -r '.context_window.total_input_tokens // 0')
out_tok=$(printf '%s' "$input" | jq -r '.context_window.total_output_tokens // 0')
total_tok=$((in_tok + out_tok))

if [ "$total_tok" -ge 1000 ]; then
  tok_display="$((total_tok / 1000))k tok"
else
  tok_display="${total_tok} tok"
fi

used_pct=$(printf '%s' "$input" | jq -r '.context_window.used_percentage // empty')

parts=("$model" "$folder")
[ -n "$branch" ] && parts+=("$branch")
parts+=("$tok_display")
[ -n "$used_pct" ] && parts+=("$(printf '%.0f' "$used_pct")% ctx")

out=""
for p in "${parts[@]}"; do
  if [ -z "$out" ]; then
    out="$p"
  else
    out="$out | $p"
  fi
done

printf '%s' "$out"

#!/usr/bin/env bash
# Runs `claude` under bubblewrap, restricted to the current working directory.
#
# Read-write:  $PWD (the project), $HOME/.claude, $HOME/.claude.json
#              (claude's own config/auth/history — not project-specific,
#              but claude needs somewhere to keep them)
# Read-only:   /nix, /etc, /run/current-system, /usr, and the user's nix
#              profile dirs — these exist purely so binaries already on
#              your $PATH (git, node, ripgrep, etc.) still resolve inside
#              the sandbox. Everything else on disk is invisible.
# Network:     shared with the host (needed for the Anthropic API itself).
#              This does NOT restrict which hosts claude can reach — only
#              which files it can touch. Layer a firewall/proxy on top if
#              you want to scope that too.
set -euo pipefail

PROJECT_DIR="$(pwd)"

bind_args=()
add_ro_bind() {
  if [ -e "$1" ]; then
    bind_args+=(--ro-bind "$1" "$1")
  fi
}

# roots needed so $PATH keeps resolving inside the sandbox
add_ro_bind /nix
add_ro_bind /etc
add_ro_bind /run/current-system
add_ro_bind /usr
add_ro_bind "$HOME/.nix-profile"
add_ro_bind "$HOME/.local/state/nix/profiles"
add_ro_bind "$HOME/.local/bin"

# claude's own state — bound read-write, live (not copied)
if [ -e "$HOME/.claude" ]; then
  bind_args+=(--bind "$HOME/.claude" "$HOME/.claude")
fi
if [ -e "$HOME/.claude.json" ]; then
  bind_args+=(--bind "$HOME/.claude.json" "$HOME/.claude.json")
fi

exec bwrap \
  --unshare-all --share-net \
  --die-with-parent \
  --proc /proc \
  --dev /dev \
  --tmpfs /tmp \
  "${bind_args[@]}" \
  --bind "$PROJECT_DIR" "$PROJECT_DIR" \
  --chdir "$PROJECT_DIR" \
  --setenv HOME "$HOME" \
  claude "$@"

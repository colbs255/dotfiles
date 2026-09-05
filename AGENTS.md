# AGENTS.md

Guidance for AI coding agents working in this repo.

## What this is

Personal dotfiles managed with Nix flakes + home-manager, targeting NixOS (primary)
and macOS. `flake.nix` exposes:

- `nixosConfigurations.nixos` — system config (`config/configuration.nix`)
- `homeConfigurations.colby` — user config (`config/home.nix`)

## Adding or changing a tool's config

1. Put the native config file(s) under `config/<tool>/` using that tool's own
   format — don't wrap it in Nix (no `services.<tool>` home-manager modules
   unless there's a specific reason; this repo consistently uses plain
   `xdg.configFile` symlinks + `home.packages` instead, even when a home-manager
   module exists).
2. Add the package to `home.packages` in `config/home.nix` if it's new.
3. Add the `xdg.configFile` mapping in `config/home.nix`.
4. If the tool needs autostarting under Hyprland, add it to the
   `hl.on("hyprland.start", ...)` block in `config/hypr/hyprland.lua` using
   `hl.exec_cmd(...)`.

## Updating

1. Run `just update` and commit the changes.
2. Run `just build-system` to verify system
3. Run `just build-home` to verify home
4. Make a pr

## Build / apply changes

- `just build-home` — user-level config
- `just build-system` — NixOS system config, root-owned

Always run `just build-home` after editing anything under `config/` to verify it
builds before considering a config change done. `build-system` touches the whole
machine (bootloader, system packages, users) — don't run it unless the change is
actually in `config/configuration.nix` or `config/hardware-configuration.nix`.

## Formatting / lint

- `just format` — format nix, lua, and bash
- `just lint` — check/lint nix, lua, and bash

## Git / PRs

- Feature branches + PRs via `gh pr create`, not direct commits to `main`.
- Commit messages: short imperative summary, no strict convention enforced
  beyond that.

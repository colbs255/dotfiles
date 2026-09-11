---
name: nix-repo-scaffold
description: "Scaffold a new project repo with a Nix flake dev shell, justfile, and direnv, for any language/toolchain. Use when the user asks to init/start/scaffold a new project or repo, especially if they mention Nix, a flake, just/justfile, or direnv."
---

# Nix-backed repo scaffold

Set up a fresh repo like this, in order. The core principle: every tool the
project needs (compilers, runtimes, formatters, linters, CLIs) comes from the
flake's devShell — nothing is assumed to be installed globally.

1. `git init`
2. `flake.nix` — devShell listing every package the project needs (compiler/
   runtime, formatter, linter, language server, build tool, etc., based on
   the project's language). Use `flake-utils.lib.eachDefaultSystem`. Set any
   env vars the toolchain needs (e.g. backtrace/debug flags).
3. Stage `flake.nix` (`git add flake.nix`) — Nix flakes ignore untracked
   files, so this must happen before any `nix develop`/`nix flake check`.
4. If the language has a project-init generator (`cargo init`, `npm init`,
   `go mod init`, etc.), run it through the shell: `nix develop -c <init
   command>`.
5. Add build output dirs and `.direnv/` to `.gitignore`.
6. `justfile` with recipes matching the project's native tooling: `build`,
   `run *ARGS`, `test`, `fmt`, `lint`, `check` (fmt + lint + test), `clean`.
   Default recipe runs `build`.
7. `.envrc` containing just `use flake`, then `direnv allow .`.
8. Verify: `nix develop -c just build && nix develop -c just run` (adjust to
   whatever recipes make sense for the project).
9. Check that everything just pinned is actually current — don't just accept
   whatever version got templated in:
   - `flake.nix` inputs: point `nixpkgs` at a current channel (e.g.
     `nixos-unstable`), then run `nix flake update` and commit the resulting
     `flake.lock`.
   - Any GH Actions workflow (existing, or added as part of this scaffold):
     check that every `uses:` action is pinned to its latest released
     version/tag, not whatever a template happened to have.
   - Any toolchain-level dependency file the init generator produced
     (`Cargo.toml`, `package.json`, `go.mod`, etc.): check that the
     dependencies it declares resolve to current versions, using that
     ecosystem's own tooling (e.g. `cargo update`, `npm outdated`/`npm
     update`, `go get -u`) run through `nix develop -c`.
10. `git add -A` and commit.

Keep it minimal — don't add dependencies, CI, or extra tooling unless asked.

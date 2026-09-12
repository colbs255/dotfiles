---
name: github-actions
description: "Create GitHub Actions workflows for Nix flake-based repos, installing Nix with nix-quick-install-action and running every command through the project's devShell. Use when the user asks to add/create a GitHub Actions workflow, CI, or automate checks/builds/deploys via GitHub Actions."
---

# GitHub Actions for Nix repos

Core principle: every command in a workflow runs through the project's Nix
flake devShell (`nix develop -c <command>`) — never assume a tool is
preinstalled on the runner. Each job gets its own checkout + Nix install
steps since GitHub Actions jobs run in isolated VMs.

1. Check the current release tag for every action before writing anything —
   don't reuse whatever version happened to be in a prior workflow:
   ```sh
   gh api repos/actions/checkout/releases/latest --jq .tag_name
   gh api repos/nixbuild/nix-quick-install-action/releases/latest --jq .tag_name
   ```
2. Put the workflow under `.github/workflows/<name>.yml`. Name it for what
   it does (`check.yml` for PR validation, `apply.yml`/`deploy.yml` for
   push-to-main automation), not generically `ci.yml`.
3. Every job:
   - `runs-on: ubuntu-latest`
   - `uses: actions/checkout@v<N>`
   - `uses: nixbuild/nix-quick-install-action@v<N>` — this is the "quick
     install" action: faster than `cachix/install-nix-action` on ephemeral
     CI runners since it does a single-user install with no daemon and no
     cache warmup.
   - Every subsequent step runs its command through `nix develop -c
     <command>` (or `nix develop --command bash -c '...'` for a shell
     pipeline), so the flake's devShell stays the single source of truth
     for tool versions instead of whatever the runner image ships with.
4. Minimal `permissions:` block — default to `contents: read`; add narrower
   scopes only for what a job actually needs (e.g. `id-token: write` for
   cloud OIDC auth, `pull-requests: write` to comment on PRs).
5. Add a `concurrency:` group keyed on workflow + ref so superseded runs on
   the same branch/PR get cancelled:
   ```yaml
   concurrency:
     group: ${{ github.workflow }}-${{ github.ref }}
     cancel-in-progress: true
   ```
   Use `cancel-in-progress: false` for deploy/apply workflows, where an
   in-flight apply shouldn't be killed mid-run.
6. Trigger on `pull_request` for validation/check workflows, `push: branches:
   [main]` for deploy/apply workflows that should only run after merge.
7. Split unrelated validation concerns into separate jobs (e.g. lint nix,
   lint lua, lint shell) instead of one monolithic job — they run in
   parallel, and a failure in one doesn't obscure the others.
8. Example (PR validation workflow):
   ```yaml
   name: check

   on:
     pull_request:

   concurrency:
     group: ${{ github.workflow }}-${{ github.ref }}
     cancel-in-progress: true

   permissions:
     contents: read

   jobs:
     validate:
       runs-on: ubuntu-latest
       steps:
         - uses: actions/checkout@v7
         - uses: nixbuild/nix-quick-install-action@v35
         - name: check
           run: nix develop -c just check
   ```
9. Verify: confirm every `run:` command works locally via `nix develop -c
   <command>` first, then push the branch (or open the PR) and check the
   workflow run is green.

Keep it minimal — one workflow file per concern, no steps beyond what's
needed to run the project's existing `just` recipes in CI.

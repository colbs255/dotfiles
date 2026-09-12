---
description: Ships the current branch - opens a PR if none exists, resolves merge conflicts and lint/format failures, verifies the build, and merges once checks pass. Use when the user says "ship it" or asks to merge/land the current branch's PR.
---

```
Progress:
- [ ] PR exists
- [ ] Synced with main, no conflicts
- [ ] just format / just lint clean
- [ ] just build-home passes (if config/ changed)
- [ ] Checks green
- [ ] Merged
```

## 1. Ensure a PR exists

`gh pr view --json url,state,mergeable,mergeStateStatus`. If none exists: push
(`git push -u origin HEAD` if no upstream yet), then `gh pr create`. Infer the title/body
from the branch's commits — imperative summary, no type prefix, matching this repo's
existing PR titles.

## 2. Sync with main

If `mergeStateStatus` is `BEHIND` or `DIRTY`, merge (or rebase — match however this branch
has resolved conflicts so far) `main` into the branch. Resolve conflicts by reading both
sides; never blindly `git checkout --ours/--theirs`.

## 3. Fix lint/format

Run `just format` and `just lint`. Fix anything flagged, then push.

## 4. Verify the build

If anything under `config/` changed in steps 2-3, run `just build-home` before continuing.
Also run `just build-system` if `config/configuration.nix` or
`config/hardware-configuration.nix` changed.

## 5. Wait for checks

Poll `gh pr checks <PR>` until it finishes.

- Failure caused by lint/format/conflicts → go back to step 2 or 3, then re-check.
- Any other failure (failing test, real type error, etc.) → stop and report to the user
  instead of guessing at a fix — that needs a judgment call about intent, not a shortcut.

## 6. Merge

This repo only allows squash merges: `gh pr merge --squash`. Confirm with the user first if
the PR touches `config/configuration.nix`, `config/hardware-configuration.nix`, or is
otherwise system-level/high-blast-radius.

Report the PR URL, what was fixed, and the merge result.

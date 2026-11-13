# Cleanup pass

Run after every batch and whenever no worktree is active. Only when no worker or test run is active (`ps`, `git worktree list`). Never delete what you have not looked at.

- Worktrees and local branches whose PR is merged: `sh scripts/core/worktree-done.sh <branch>` (it compares content, not commit counts). Unmerged experiments: one ledger line, then delete only with the owner's say-so or when the ledger says rejected.
- Uncommitted files: needed ones are committed on a proper branch; stray ones are saved as a patch outside the repo first, then dropped. Never `git stash -u` or `git checkout --theirs .` in a shared checkout.
- Files out of place move to their path (queue files to `CORE_QUEUE_DIR`, scripts to `scripts/`, notes to `docs/`).
- Test databases and temp credential files created by runs: remove when no suite runs. The dev database stays.
- Build output when `doctor.sh` reports low disk.
- Compact merged briefs, delete notes files, trim STATUS to its cap.

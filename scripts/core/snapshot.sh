#!/bin/sh
# Save everything that does not live safely in one place: all branches as a git bundle, uncommitted work as a
# patch, and copies of ledger/STATUS/plan. Output: $CORE_QUEUE_DIR/snapshots/<timestamp>/ (outside the repo).
. "$(dirname "$0")/lib.sh"; cd "$CORE_ROOT" || exit 1
q=${CORE_QUEUE_DIR:-../core-queue}; out="$q/snapshots/$(date +%Y%m%d-%H%M%S)"; mkdir -p "$out" || exit 1
git bundle create "$out/repo.bundle" --all >/dev/null 2>&1 && echo "bundle: $out/repo.bundle"
git diff HEAD > "$out/uncommitted.patch"; [ -s "$out/uncommitted.patch" ] && echo "patch:  $out/uncommitted.patch" || rm -f "$out/uncommitted.patch"
git ls-files --others --exclude-standard > "$out/untracked.txt"; [ -s "$out/untracked.txt" ] && tar -czf "$out/untracked.tgz" -T "$out/untracked.txt" && echo "untracked files archived"
for f in "$CORE_LEDGER" "$CORE_STATUS_FILE" docs/PROGRESS.md docs/open-questions.md; do [ -f "$f" ] && cp "$f" "$out/"; done
[ -d docs/plan ] && cp -R docs/plan "$out/plan"
git worktree list > "$out/worktrees.txt"
echo "snapshot: $out (secrets and databases are NOT included; see the stack database skill to recreate data)"

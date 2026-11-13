#!/bin/sh
# Read-only digest of a run: contract, next action, ledger tail, branches, worktrees, PRs, queue log, disk.
. "$(dirname "$0")/lib.sh"; cd "$CORE_ROOT" || exit 1
echo "== $(repo_name) @ $(git symbolic-ref --short HEAD 2>/dev/null) · $(date '+%Y-%m-%d %H:%M')"
if [ -f "$CORE_LEDGER" ]; then
  echo "== Next action"; grep -m1 '^\*\*Next action' "$CORE_LEDGER" || echo "(none recorded)"
  echo "== Ledger tail"; tail -n 8 "$CORE_LEDGER"
else echo "== no ledger yet"; fi
[ -f "$CORE_STATUS_FILE" ] && { echo "== STATUS (Now)"; awk '/^## Now/{f=1;next} /^## /{f=0} f&&NF' "$CORE_STATUS_FILE" | head -6; }
echo "== Worktrees"; git worktree list
echo "== Local branches ahead of base"
base=origin/$CORE_BASE_BRANCH; git rev-parse -q --verify "$base" >/dev/null || base=$CORE_BASE_BRANCH
git for-each-ref --format='%(refname:short)' refs/heads | while read -r b; do
  [ "$b" = "$CORE_BASE_BRANCH" ] && continue; n=$(git rev-list --count "$base..$b" 2>/dev/null); echo "  $b (+$n)"; done
command -v gh >/dev/null && { echo "== Open PRs"; gh pr list --limit 10 2>/dev/null || echo "  (gh unavailable)"; }
q=${CORE_QUEUE_DIR:-../core-queue}; [ -f "$q/queue.log" ] && { echo "== Queue log tail"; tail -n 8 "$q/queue.log"; }
echo "== Disk"; df -h . | awk 'NR==2{print "  free " $4 " of " $2}'

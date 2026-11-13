#!/bin/sh
# Remove a finished worktree and its local branch: worktree-done.sh <type/name>
# Refuses while the branch has commits whose CONTENT is not in the base (squash merges look "ahead",
# so it compares content with `git diff`, not commit counts). Use --force only when the ledger says rejected.
. "$(dirname "$0")/lib.sh"
force=0; [ "$1" = "--force" ] && { force=1; shift; }
[ -n "$1" ] || die "usage: worktree-done.sh [--force] <type/name>"
branch=$1; cd "$CORE_ROOT" || exit 1
dir="$CORE_WORKTREE_PREFIX$(repo_name)-$(printf '%s' "$branch" | tr '/' '-')"
if [ $force = 0 ]; then
  base=origin/$CORE_BASE_BRANCH; git rev-parse -q --verify "$base" >/dev/null || base=$CORE_BASE_BRANCH
  [ -z "$(git diff --stat "$base"..."$branch" 2>/dev/null)" ] || die "$branch still differs from $base. Merge it, or record it as rejected and use --force."
fi
[ -d "$dir" ] && git worktree remove --force "$dir"
git branch -D "$branch" >/dev/null 2>&1; git worktree prune; echo "removed $branch"

#!/bin/sh
# Create an isolated worktree for one worker: worktree-new.sh <type/name> [base-ref]
# One worktree per worker; two writers never share files.
. "$(dirname "$0")/lib.sh"
[ -n "$1" ] || die "usage: worktree-new.sh <type/name> [base-ref]"
branch=$1; base=${2:-origin/$CORE_BASE_BRANCH}
printf '%s' "$branch" | grep -Eq "^($CORE_WORK_TYPES)/[A-Za-z0-9][A-Za-z0-9._-]*$" || die "branch must be <type>/<kebab-name>, type in $CORE_WORK_TYPES"
cd "$CORE_ROOT" || exit 1
git fetch -q origin 2>/dev/null || echo "note: no origin to fetch; using local $CORE_BASE_BRANCH" >&2
git rev-parse -q --verify "$base" >/dev/null || base=$CORE_BASE_BRANCH
dir="$CORE_WORKTREE_PREFIX$(repo_name)-$(printf '%s' "$branch" | tr '/' '-')"
git worktree add -q "$dir" -b "$branch" "$base" || exit 1
echo "$dir"

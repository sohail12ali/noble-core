#!/bin/sh
# PreToolUse hook for Bash: the hard limits in CLAUDE.md, enforced instead of hoped for.
# Always: no commit/push on a protected branch, no push to one, no force-push, no --no-verify.
# In an unattended run (CORE_UNATTENDED=1, set by run/loop.sh): also no merging, no deploy-style gh actions.
input=$(cat)
case "$input" in *git*|*gh\ *) ;; *) exit 0 ;; esac
root=${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null)}
[ -f "$root/core.env" ] && . "$root/core.env"
: "${PROTECTED_BRANCHES:=main}"
no() { echo "Blocked by scripts/guard.sh: $1" >&2; exit 2; }
case "$input" in
  *"push --force"*|*"push -f "*|*"--force-with-lease"*|*"push origin +"*) no "force-push is never allowed." ;;
  *"--no-verify"*) no "--no-verify skips checks. Fix the cause." ;;
esac
branch=$(git -C "$root" symbolic-ref --short HEAD 2>/dev/null)
for p in $PROTECTED_BRANCHES; do
  case "$input" in
    *"git commit"*|*"git push"*|*"git merge"*|*"git rebase"*|*"git reset --hard"*)
      [ "$branch" = "$p" ] && no "'$p' is protected. Work on a run or work branch; the owner merges." ;;
  esac
  case "$input" in
    *"git push"*" $p"\"*|*"git push"*" $p "*|*"git push"*":$p"*) no "pushing to '$p' is the owner's step." ;;
    *"git branch -D $p"*|*"push"*"--delete $p"*) no "'$p' is protected." ;;
  esac
done
if [ "${CORE_UNATTENDED:-0}" = 1 ]; then
  case "$input" in
    *"gh pr merge"*|*"gh release"*|*"gh repo delete"*|*"gh workflow run"*|*"gh secret"*) no "unattended runs do not merge, release or touch repo settings. Put it in run/INBOX.md." ;;
  esac
fi
exit 0

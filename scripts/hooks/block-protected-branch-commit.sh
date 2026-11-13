#!/bin/sh
# PreToolUse hook for Bash. Refuses `git commit` / `git push` when the branch is
#   - protected (CORE_PROTECTED_BRANCHES), or
#   - not named <type>/<kebab-name> with a type from CORE_WORK_TYPES.
# Layer branches (layer/N-name) are allowed so the template itself can be maintained.
input=$(cat)
case "$input" in *"git commit"*|*"git push"*) ;; *) exit 0 ;; esac
root=${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null)}
[ -f "$root/.core/config.env" ] && . "$root/.core/config.env"
: "${CORE_PROTECTED_BRANCHES:=main}" "${CORE_WORK_TYPES:=feature|bugfix|hotfix|docs|chore}"
branch=$(git symbolic-ref --short HEAD 2>/dev/null) || exit 0
for p in $CORE_PROTECTED_BRANCHES; do
  if [ "$branch" = "$p" ]; then
    echo "Blocked: '$branch' is protected. Cut a work branch (<type>/<name>) and open a PR." >&2; exit 2
  fi
done
if ! printf '%s' "$branch" | grep -Eq "^(($CORE_WORK_TYPES)/[A-Za-z0-9][A-Za-z0-9._-]*|layer/[0-9]+-[a-z0-9-]+)$"; then
  echo "Blocked: branch '$branch' must be <type>/<kebab-name> with type $CORE_WORK_TYPES. Rename: git branch -m <type>/<name>." >&2; exit 2
fi
exit 0

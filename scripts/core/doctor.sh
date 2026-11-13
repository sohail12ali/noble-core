#!/bin/sh
# Pre-flight and hygiene check. Run before any long run and after cleanup. Read-only. Exit 1 on any FAIL.
. "$(dirname "$0")/lib.sh"; cd "$CORE_ROOT" || exit 1; fail=0
ok() { echo "ok    $*"; }; warn() { echo "WARN  $*"; }; bad() { echo "FAIL  $*"; fail=1; }
for t in git python3; do command -v $t >/dev/null && ok "$t present" || bad "$t missing"; done
command -v gh >/dev/null && ok "gh present" || warn "gh missing (PRs and merges need it)"
[ -f .core/config.env ] && ok "config .core/config.env" || bad ".core/config.env missing"
branch=$(git symbolic-ref --short HEAD 2>/dev/null || echo detached); ok "branch $branch"
[ -z "$(git status --porcelain)" ] && ok "working tree clean" || warn "uncommitted changes (never edit a checkout that holds someone else's WIP; use a worktree)"
n=$(git worktree list | wc -l | tr -d ' '); [ "$n" -le 1 ] && ok "no extra worktrees" || warn "$((n-1)) worktree(s) active: git worktree list"
if [ -f "$CORE_STATUS_FILE" ]; then
  l=$(wc -l < "$CORE_STATUS_FILE" | tr -d ' '); b=$(wc -c < "$CORE_STATUS_FILE" | tr -d ' ')
  [ "$l" -le "$CORE_STATUS_MAX_LINES" ] && [ "$b" -le "$CORE_STATUS_MAX_BYTES" ] && ok "STATUS $l lines, $b bytes" || bad "STATUS over cap ($l lines, $b bytes; cap $CORE_STATUS_MAX_LINES / $CORE_STATUS_MAX_BYTES)"
else warn "no $CORE_STATUS_FILE yet (copy docs/templates/STATUS.md)"; fi
big=$(find .claude/skills -name SKILL.md -size +"${CORE_SKILL_MAX_BYTES}"c 2>/dev/null)
[ -z "$big" ] && ok "skills under $CORE_SKILL_MAX_BYTES bytes" || { warn "skills over cap (move examples to a sub-file):"; echo "$big"; }
[ -f "$CORE_LEDGER" ] && ok "ledger present" || warn "no ledger yet (scripts/core/ledger.sh creates it)"
free=$(df -Pk . | awk 'NR==2{printf "%d", $4/1048576}'); [ "$free" -ge "$CORE_MIN_FREE_GB" ] && ok "free disk ${free} GB" || bad "free disk ${free} GB < $CORE_MIN_FREE_GB GB: clean build output first"
[ -f stack/profile.env ] && ok "stack profile present" || warn "no stack profile: generic mode (layer 0)"
exit $fail

#!/bin/sh
# Shared helpers. Source with: . "$(dirname "$0")/lib.sh"
CORE_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
[ -f "$CORE_ROOT/.core/config.env" ] && . "$CORE_ROOT/.core/config.env"
: "${CORE_BASE_BRANCH:=main}" "${CORE_PROTECTED_BRANCHES:=main}" "${CORE_LEDGER:=.autonomous/ledger.md}"
: "${CORE_WORK_TYPES:=feature|bugfix|hotfix|docs|chore}" "${CORE_WORKTREE_PREFIX:=../}"
: "${CORE_STATUS_FILE:=docs/STATUS.md}" "${CORE_STATUS_MAX_LINES:=40}" "${CORE_STATUS_MAX_BYTES:=3072}"
: "${CORE_SKILL_MAX_BYTES:=6144}" "${CORE_MIN_FREE_GB:=10}"
repo_name() { basename "$CORE_ROOT"; }
die() { echo "error: $*" >&2; exit 1; }

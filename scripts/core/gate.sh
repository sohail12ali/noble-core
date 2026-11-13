#!/bin/sh
# Run a gate from the stack profile: gate.sh focused|changed|all
#   focused  lint + the focused test command (while building)
#   changed  the merge gate: tests for what changed
#   all      everything CI would run (promotions, shared infrastructure, on request)
. "$(dirname "$0")/lib.sh"; . "$(dirname "$0")/_profile.sh"
mode=${1:-focused}
case "$mode" in
  focused) run "$BACKEND_LINT_CMD" && run "$FRONTEND_LINT_CMD" && run "${TEST_FOCUSED_CMD:-}" ;;
  changed) run "$BACKEND_LINT_CMD" && run "$FRONTEND_LINT_CMD" && run "${TEST_CHANGED_CMD:-}" ;;
  all)     run "$BACKEND_BUILD_CMD" && run "$FRONTEND_BUILD_CMD" && run "${TEST_ALL_CMD:-}" ;;
  *) die "usage: gate.sh focused|changed|all" ;;
esac
rc=$?
[ $rc = 0 ] && [ "$RAN" = 0 ] && { echo "gate $mode: NO GATE DEFINED in stack/profile.env (a gate that runs nothing is not a pass)"; exit 2; }
[ $rc = 0 ] && echo "gate $mode: GREEN" || echo "gate $mode: RED"; exit $rc

#!/bin/sh
# The gate. Runs VERIFY_CMD from core.env. Exit 0 green, 1 red, 3 no gate defined (never a pass).
cd "$(git rev-parse --show-toplevel)" || exit 1
. ./core.env
[ -n "${VERIFY_CMD:-}" ] || { echo "verify: NO GATE DEFINED (set VERIFY_CMD in core.env). Unverified is not a pass."; exit 3; }
echo "+ $VERIFY_CMD"
if sh -c "$VERIFY_CMD"; then echo "verify: GREEN"; else echo "verify: RED"; exit 1; fi

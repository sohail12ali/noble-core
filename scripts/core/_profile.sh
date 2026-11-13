#!/bin/sh
# Source after lib.sh: loads stack/profile.env into the environment (KEY=value lines only).
[ -f "$CORE_ROOT/stack/profile.env" ] || die "no stack/profile.env (copy stack/profile.example.env or a preset, then run apply_stack.py)"
set -a; . "$CORE_ROOT/stack/profile.env"; set +a
RAN=0
run() { [ -n "$1" ] && [ "$1" != none ] || { echo "skip: not defined in profile"; return 0; }; RAN=$((RAN+1)); echo "+ $1"; (cd "$CORE_ROOT" && sh -c "$1"); }

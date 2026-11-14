#!/bin/sh
# Run a command while holding a named lock shared by every worktree of this repository.
#   sh scripts/lock.sh testdb npm run test:integration
# Use it for anything parallel workers would collide on: a test database, a port, a device, the gate.
# Waits up to LOCK_WAIT_SEC (default 3600). A lock whose holder has died is taken over.
[ $# -ge 2 ] || { echo "usage: lock.sh <name> <command...>" >&2; exit 2; }
name=$1; shift
dir=$(cd "$(git rev-parse --git-common-dir)" && pwd)/core-locks; mkdir -p "$dir"
lock="$dir/$name.lock"; waited=0; max=${LOCK_WAIT_SEC:-3600}
until mkdir "$lock" 2>/dev/null; do
  pid=$(cat "$lock/pid" 2>/dev/null)
  if [ -n "$pid" ] && ! kill -0 "$pid" 2>/dev/null; then rm -f "$lock/pid"; rmdir "$lock" 2>/dev/null; continue; fi
  [ "$waited" -ge "$max" ] && { echo "lock $name: still held after ${max}s (holder pid ${pid:-unknown})" >&2; exit 75; }
  sleep 2; waited=$((waited + 2))
done
echo $$ > "$lock/pid"
trap 'rm -f "$lock/pid"; rmdir "$lock" 2>/dev/null' EXIT
trap 'exit 130' INT TERM
"$@"

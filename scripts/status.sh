#!/bin/sh
# One look at a run, from the files: sh scripts/status.sh
cd "$(git rev-parse --show-toplevel)" || exit 1
echo "branch: $(git symbolic-ref --short HEAD 2>/dev/null)   running: $([ -d run/logs/.lock ] && echo yes || echo no)"
sed -n '1,3p' run/STATE.md | grep -v '^$'
echo "open questions: $(grep -cE '^## .*\(open\)' run/INBOX.md 2>/dev/null)"
[ -f run/logs/loop.log ] && { echo "--- loop"; tail -n 6 run/logs/loop.log; }
echo "--- last commits"; git log --oneline -5

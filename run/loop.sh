#!/usr/bin/env bash
# The unattended run. Starts a fresh agent session again and again until the plan is done, the agent is
# blocked, or a limit is hit. Each session reads the repo, not a transcript, so context loss cannot hurt.
# The loop measures (commits, gate) itself and writes run/REPORT.md from those measurements.
#
#   bash run/loop.sh                 # start or continue
#   nohup bash run/loop.sh > /dev/null 2>&1 &     # overnight, detached
#   touch run/STOP                   # ask it to stop after the current session
set -u
ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || { echo "not a git repository"; exit 1; }
cd "$ROOT" || exit 1
. ./core.env
: "${BASE_BRANCH:=main}" "${PROTECTED_BRANCHES:=main}" "${ENGINE:=claude}" "${MODEL:=}" "${ENGINE_CMD:=}"
: "${MAX_ITERATIONS:=40}" "${MAX_HOURS:=10}" "${ITERATION_TIMEOUT_MIN:=120}" "${BUDGET_USD_PER_ITERATION:=20}"
: "${MAX_STALLS:=3}" "${RETRY_SLEEP_MIN:=15}" "${ON_FINISH:=none}" "${VERIFY_CMD:=}"
LOGS=run/logs; mkdir -p "$LOGS"
say() { printf '%s %s\n' "$(date '+%m-%d %H:%M')" "$*" | tee -a "$LOGS/loop.log"; }
die() { echo "loop: $*" >&2; exit 1; }
status() { sed -n 's/^Status:[[:space:]]*\([a-z]*\).*/\1/p' run/STATE.md 2>/dev/null | head -1; }

# --- preflight -------------------------------------------------------------
[ -f PLAN.md ] || die "PLAN.md missing"
grep -q '^TEMPLATE:' PLAN.md && die "PLAN.md is still the template. Fill it in (skill: plan) and delete the TEMPLATE line."
[ -z "$(git status --porcelain)" ] || die "working tree is not clean. Commit or stash your own work first; the run must not mix with it."
if [ -z "$ENGINE_CMD" ]; then
  case "$ENGINE" in claude) command -v claude >/dev/null || die "claude CLI not found" ;;
                    cursor) command -v agent  >/dev/null || die "cursor agent CLI not found" ;;
                    *) die "ENGINE must be claude or cursor (or set ENGINE_CMD)" ;; esac
fi
mkdir "$LOGS/.lock" 2>/dev/null || die "another loop is running (or crashed: remove $LOGS/.lock)"
trap 'rmdir "$LOGS/.lock" 2>/dev/null' EXIT
branch=$(git symbolic-ref --short HEAD)
for p in $PROTECTED_BRANCHES; do
  if [ "$branch" = "$p" ]; then branch="run/$(date +%Y%m%d-%H%M)"; git switch -q -c "$branch" || die "could not create $branch"; fi
done
START_SHA=$(git rev-parse HEAD); START_TS=$(date +%s); GATE_AT_START=$VERIFY_CMD
rm -f run/STOP "$LOGS/last-verify.txt"
export CORE_UNATTENDED=1
say "run start on $branch (engine ${ENGINE_CMD:+custom}${ENGINE_CMD:-$ENGINE}, max $MAX_ITERATIONS sessions / $MAX_HOURS h)"

engine() {  # prompt on stdin
  local secs=$((ITERATION_TIMEOUT_MIN * 60))
  if [ -n "$ENGINE_CMD" ]; then perl -e 'alarm shift; exec @ARGV' "$secs" sh -c "$ENGINE_CMD"
  elif [ "$ENGINE" = claude ]; then
    perl -e 'alarm shift; exec @ARGV' "$secs" claude -p ${MODEL:+--model "$MODEL"} --settings run/unattended.settings.json \
      --permission-mode acceptEdits --max-budget-usd "$BUDGET_USD_PER_ITERATION" --output-format json
  else
    perl -e 'alarm shift; exec @ARGV' "$secs" agent -p ${MODEL:+--model "$MODEL"} --trust --sandbox enabled --force --output-format json
  fi
}

# --- the loop --------------------------------------------------------------
i=0; stalls=0; reason="session limit ($MAX_ITERATIONS) reached"; verify="not run"
while [ "$i" -lt "$MAX_ITERATIONS" ]; do
  [ -f run/STOP ] && { reason="stopped by the owner (run/STOP)"; break; }
  [ $(( ($(date +%s) - START_TS) / 3600 )) -ge "$MAX_HOURS" ] && { reason="time limit ($MAX_HOURS h) reached"; break; }
  i=$((i + 1)); before=$(git rev-parse HEAD); t0=$(date +%s)
  engine < run/prompt.md > "$LOGS/session-$i.out" 2> "$LOGS/session-$i.err"; rc=$?
  took=$(( $(date +%s) - t0 ))
  if [ -n "$(git status --porcelain)" ]; then   # nothing is lost between sessions
    git add -A && git commit -q -m "wip: work left uncommitted at the end of session $i (saved by the loop)"
  fi
  new=$(git rev-list --count "$before"..HEAD)
  if [ -n "$VERIFY_CMD" ]; then
    if sh scripts/verify.sh > "$LOGS/last-verify.txt" 2>&1; then verify=green; else verify=RED; fi
  else verify="no gate defined"; fi
  st=$(status); say "session $i: exit $rc, ${took}s, +$new commits, gate $verify, status ${st:-missing}"
  case "$st" in
    done)    if [ "$verify" != RED ]; then reason="agent reports done"; break; fi
             say "session $i: status says done but the gate is red; continuing" ;;
    blocked) reason="agent is blocked: everything left needs the owner (see run/INBOX.md)"; break ;;
  esac
  if [ "$new" -eq 0 ]; then
    stalls=$((stalls + 1))
    [ "$stalls" -ge "$MAX_STALLS" ] && { reason="no new commits in $MAX_STALLS sessions in a row (stuck)"; break; }
    if [ "$took" -lt 60 ] && [ "$RETRY_SLEEP_MIN" -gt 0 ]; then
      say "session $i ended in under a minute with no work (usage limit or sign-in?); waiting $RETRY_SLEEP_MIN min"; sleep $((RETRY_SLEEP_MIN * 60))
    fi
  else stalls=0; fi
done

# --- report: measurements, not claims --------------------------------------
. ./core.env
{
  echo "# Run report"; echo
  echo "- **Stopped because:** $reason"
  echo "- **Branch:** \`$branch\` · **Sessions:** $i · **Elapsed:** $(( ($(date +%s) - START_TS) / 60 )) min"
  echo "- **Commits:** $(git rev-list --count "$START_SHA"..HEAD) · **Changed:** $(git diff --shortstat "$START_SHA"..HEAD | sed 's/^ //')"
  echo "- **Gate (run by the loop):** $verify$([ "$verify" = "no gate defined" ] && echo ' — nothing here is verified')"
  [ "${VERIFY_CMD:-}" != "$GATE_AT_START" ] && echo "- **WARNING: VERIFY_CMD changed during the run.** Was: \`$GATE_AT_START\` Now: \`${VERIFY_CMD:-}\`"
  echo "- **Agent's status:** $(status)"
  echo; echo "## Questions waiting for you"; echo
  grep -E '^## .*\(open\)' run/INBOX.md 2>/dev/null | sed 's/^## /- /' || true
  grep -qE '^## .*\(open\)' run/INBOX.md 2>/dev/null || echo "None."
  left=$(git worktree list | tail -n +2); stray=$(git for-each-ref --format='%(refname:short)' refs/heads/work/ refs/heads/worktree- 2>/dev/null)
  if [ -n "$left$stray" ]; then echo; echo "## Left in flight (worktrees and work branches not cleaned up)"; echo; echo '```'; echo "$left"; echo "$stray"; echo '```'; fi
  echo; echo "## Commits"; echo; git log --oneline "$START_SHA"..HEAD | sed 's/^/- /' | head -60
  if [ "$verify" = RED ]; then echo; echo "## Gate output (last 30 lines)"; echo; echo '```'; tail -30 "$LOGS/last-verify.txt"; echo '```'; fi
  echo; echo "Details: \`run/STATE.md\`, \`run/JOURNAL.md\`, \`run/INBOX.md\`, \`docs/DECISIONS.md\`, session logs in \`run/logs/\`."
  echo "The agent's own account is in the journal; the numbers above were measured by the loop."
} > run/REPORT.md
say "run end: $reason (report: run/REPORT.md)"
case "$ON_FINISH" in
  push|pr) git push -q -u origin "$branch" 2>>"$LOGS/loop.log" && say "pushed $branch"
           [ "$ON_FINISH" = pr ] && gh pr create --draft --base "$BASE_BRANCH" --head "$branch" --title "Run: $branch" --body-file run/REPORT.md >>"$LOGS/loop.log" 2>&1 && say "draft pull request opened" ;;
esac
exit 0

#!/bin/zsh
# Sequential worker queue for unattended runs. Copy to $CORE_QUEUE_DIR and edit TASKS, or run in place.
#   nohup zsh scripts/core/queue-runner.sh > "$CORE_QUEUE_DIR/runner.out" 2>&1 &
# Per task: own worktree -> one worker (cursor or claude CLI) -> gate command -> merge only if green.
# Task file: $CORE_QUEUE_DIR/t<id>.md (a self-contained prompt). Logs: queue.log, out<id>.json, err<id>.txt.
# Needs: GATE_CMD (shell command run in the worktree; exit 0 = green). Optional: CORE_MERGE_MODE.
ROOT=$(cd "$(dirname "$0")/../.." && pwd); . "$ROOT/.core/config.env"
Q=${CORE_QUEUE_DIR:-$ROOT/../core-queue}; mkdir -p "$Q"; GATE_CMD=${GATE_CMD:-true}
BASE=${CORE_BASE_BRANCH:-main}; MODE=${CORE_MERGE_MODE:-pr-squash}
log() { echo "$(date +%H:%M:%S) $*" >> "$Q/queue.log"; }
# id | branch | worker | PR title        worker = cursor:<model> | claude:<haiku|sonnet|opus>
TASKS=(
  "1|chore/example|claude:sonnet|Example task"
)
run_task() { id=$1 br=$2 worker=$3 title=$4
  wt=$(sh "$ROOT/scripts/core/worktree-new.sh" "$br") || { log "$id worktree failed"; return; }
  cd "$wt" || return; log "$id start ($br, $worker)"
  # macOS has no `timeout`: use perl alarm. Keep each task under ~30-90 minutes.
  case $worker in
    cursor:*) perl -e 'alarm shift; exec @ARGV' 5400 agent -p --model "${worker#cursor:}" --trust --sandbox enabled --force --output-format json < "$Q/t$id.md" > "$Q/out$id.json" 2> "$Q/err$id.txt" ;;
    claude:*) perl -e 'alarm shift; exec @ARGV' 5400 claude -p --model "${worker#claude:}" --permission-mode acceptEdits --max-budget-usd 10 --output-format json < "$Q/t$id.md" > "$Q/out$id.json" 2> "$Q/err$id.txt" ;;
  esac
  log "$id worker exit $?; commits: $(git rev-list --count "origin/$BASE"..HEAD 2>/dev/null)"
  [ "$(git rev-list --count "origin/$BASE"..HEAD 2>/dev/null)" -gt 0 ] || { log "$id no commit, left for review"; return; }
  git fetch -q origin; git merge -q "origin/$BASE" 2>&1 || { log "$id merge conflict, left for review"; return; }
  sh -c "$GATE_CMD" > "$Q/gate$id.txt" 2>&1 || { log "$id gate FAILED, left for review"; return; }
  [ "$MODE" = none ] && { log "$id green, left for review (merge mode none)"; return; }
  git push -q -u origin "$br" 2>&1 | tail -1
  gh pr create --base "$BASE" --title "$title" --body "Queued run ($worker). Local gate: green." > "$Q/pr$id.txt" 2>&1
  sleep 10; flag=--squash; [ "$MODE" = pr-merge ] && flag=--merge
  gh pr merge "$flag" --delete-branch >> "$Q/pr$id.txt" 2>&1
  cd "$ROOT"; sh scripts/core/worktree-done.sh --force "$br" >/dev/null 2>&1; log "$id merged"
}
for t in $TASKS; do IFS='|' read -r id br worker title <<< "$t"; run_task "$id" "$br" "$worker" "$title"; done
log "queue finished"

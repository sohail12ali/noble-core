---
name: monitor
description: See how a long or unattended run is doing - progress, health, stuck workers, cost and disk - from the repo's own files, and report it in a few lines. Use when the owner asks "how is it going", before and after any long wait, at checkpoints of an overnight run, or when something seems stuck.
---

# monitor: progress and health from files, not memory

```bash
sh scripts/core/progress.sh          # digest: contract, next action, ledger tail, branches, worktrees, PRs, queue log, disk
sh scripts/core/doctor.sh            # hygiene: caps, dirty tree, tools, disk
```

## What to check, in order

1. **Next action and contract** (ledger head): is the run still doing what it was told?
2. **Ledger tail**: last merged slice, last failure. No new line for much longer than a slice normally takes means stuck.
3. **Worktrees and branches**: each active worktree has a worker or a reason. Orphans go to cleanup.
4. **Queue log** (`CORE_QUEUE_DIR/queue.log`): last event time; `worker exit`, `gate FAILED`, `merge conflict`, `left for review` lines.
5. **Processes**: `ps` for the real worker/test process; a worker with no log growth for 20+ minutes is stuck. Do not `pkill` broadly; stop only your own worker.
6. **Cost and limits**: model usage limits and budgets per worker (`--max-budget-usd`); when one vendor is low, route small tasks to the other.
7. **Disk and databases**: free space above `CORE_MIN_FREE_GB`; leftover test databases and temp files.

## Reporting

Answer first, 5 lines max: state (on track | slowed | stuck | blocked on owner), merged since last report, in flight, failures with cause, what the owner must decide (each with a recommendation). Say what you did not check.

## Measuring product health

Product-level monitoring (idle cost, error rates, latency, hardware-only checks) belongs in the delivery plan: write the budget, the measuring command and the threshold, then add the check to the gate or to a checklist file. Example discipline: idle should cost close to nothing; anything needing freshness gets it on demand; record before/after numbers when tuning.

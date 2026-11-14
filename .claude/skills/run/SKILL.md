---
name: run
description: Start, watch, stop, resume and review an unattended run of PLAN.md with run/loop.sh. Use when the owner says "run it", "work overnight", "keep going while I'm away", "how is it going", "what happened last night", or wants to continue a stopped run.
---

# run

## Start

1. `PLAN.md` is real (no `TEMPLATE:` line), the tree is clean, `sh scripts/verify.sh` behaves as expected today (a gate that is already red wastes the first sessions; say so).
2. Check `core.env` with the owner if this is the first run: limits, `ON_FINISH`, engine.
3. Launch detached so it outlives this chat, then confirm the first log line:

```bash
nohup bash run/loop.sh > /dev/null 2>&1 &
```

The loop makes a `run/<date>` branch if started on a protected one, runs fresh sessions until done, blocked or a limit, and writes `run/REPORT.md`.

## Watch and stop

`sh scripts/status.sh` shows status, next action, open questions and the loop's last lines. `touch run/STOP` ends it after the current session. Do not kill sessions mid-work unless asked.

## The morning after

Read `run/REPORT.md` first: it is measured by the loop, not written by the agent. Then give the owner, in a few lines: why it stopped, whether the gate is green, what is and is not proven, and each open inbox question with its default. Check a claim against the diff before repeating it.

The owner answers in `run/INBOX.md` under **Answer**, or tells you and you write it there. Then start the loop again: it continues from `run/STATE.md`.

## When it stalls

"No new commits in N sessions" means the agent is stuck, not lazy. Read the last session log and the gate output, fix what a human can fix (a sign-in, a missing tool, an impossible check), note it in `run/STATE.md` under facts, and restart.

## Safety

The loop gives the agent broad command access (`run/unattended.settings.json`) because nobody is there to approve prompts. The guard hook and the deny list hold the hard limits, but they are a seat belt, not a cage: run it on a machine or container where the worst case is acceptable, with only test keys present.

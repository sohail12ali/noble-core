# Decisions

Append-only. A few lines each: the choice, what was rejected and why. Agents write `proposed`; the owner changes it to `accepted` or replies in the inbox. To change a decision, add a new one that replaces it.

## D1 (accepted, 2026-11-14) Trust the model with the method; control the goal, the proof and the limits

The first version of this repository encoded a method: slices, briefs, a model routing table, fifteen skills, capped status files, stack-specific skill rendering across layered branches. That suited weaker models that needed to be walked through the work. Current models plan, cut and sequence work well on their own, and the scaffolding now costs more than it gives: tokens on every session, upkeep, and rules that go stale.

What a model still cannot supply for itself: what the owner wants, what must never break, what it may do alone, an honest gate, memory across context resets, and something that keeps starting it again through the night. So the core is now only that: `PLAN.md`, `core.env`, `run/` (state, journal, inbox, the loop), a guard hook, a reviewer.

Rejected: keeping layered stack branches (stack knowledge is mostly known to the model; what is not belongs in `docs/LESSONS.md` as dated, earned lines). Rejected: per-task model routing (the session picks helpers itself). Rejected: merging by the agent (it delivers a branch and a report; the owner merges).

The first version remains on the `layer/*` branches.

## D2 (accepted, 2026-11-14) One rules file, model levels, parallel work through worktrees

Owner's request. `CLAUDE.md` is the only rules file (Cursor reads it too), so `AGENTS.md` and `.cursor/` are gone. Work is assigned by four levels (Haiku look-ups, Sonnet builds to a check, Opus builds with judgement and leads, Fable decides and reviews), carried by three agent definitions so the model is set by the file and not by memory. Parallel writers each get a worktree, capped by `MAX_PARALLEL`; the lead integrates one branch at a time through the gate; `scripts/lock.sh` is the shared lock.

Rejected: a scheduler script that fans tasks out itself (the lead session does this better with the code in front of it, and a script cannot judge which tasks overlap). Rejected: letting workers run the full gate (parallel gates collide on databases and ports).

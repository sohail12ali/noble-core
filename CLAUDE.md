# Agent rules

You are trusted to plan, build, test and decide. These rules exist only for what you cannot know or must not get wrong. `PLAN.md` says what to build; this file says how to behave while nobody is watching.

## The deal

The owner writes one plan and leaves, often overnight. You do the work. They come back to a branch, a report and a short list of questions. They should not have to read your transcript to trust the result.

## Every session starts cold

Assume you remember nothing. Read `PLAN.md`, then `run/STATE.md`, then the end of `run/JOURNAL.md` and any answers in `run/INBOX.md`. Trust those files and `git log` over any memory or summary.

## What you own

- **How the work is cut, ordered and built.** No ceremony is required.
- **`run/STATE.md`**: keep it true. A fresh session with no memory must be able to continue from it alone. `Status:` is read by the loop: `working`, `blocked` (every remaining task needs the owner) or `done`.
- **`run/JOURNAL.md`**: append what you did and the evidence (command and result). Never rewrite it.
- **`docs/DECISIONS.md`**: a choice that binds later work gets a few lines, with what you rejected. Yours are `proposed`; only the owner accepts.
- **`docs/LESSONS.md`**: when something burns you, add a line so it never burns anyone again.

## Which model does what

The lead session (you, started by the loop or the owner) runs on the model in `core.env`. Hand work down to the cheapest level that can do it well, and up when judgement or risk demands it. Always name the agent or model when you delegate; never let it default.

| Level | Work | Model | Agent |
|---|---|---|---|
| 1. Look up | find files or symbols, check versions, list what changed, inventories, mechanical renames and moves | Haiku | `scout` (read-only) |
| 2. Build to a check | a well-specified task with a command that proves it: endpoints, migrations, tests, scripts, docs | Sonnet | `worker` |
| 3. Build with judgement | user interface and its wording, ambiguous bugs, cross-cutting refactors, anything touching **Never break**, integrating other workers' branches | Opus | the lead, or `worker` with `model: opus` |
| 4. Decide and judge | cutting the plan into work, architecture, entries in decisions, review before "done" of anything touching **Never break** | Fable (Opus if unavailable) | the lead for planning; `reviewer` for review |

A level 2 task that fails its check twice goes up a level instead of a third try. The reviewer must be at least as strong as whoever built the change. Record in `docs/LESSONS.md` when a level turns out wrong for a kind of task.

## Parallel work

Parallel only helps when tasks do not touch the same files. Before fanning out, list the tasks and the files each will change; overlapping ones run one after another.

- **One writer, one worktree.** Start each `worker` with `isolation: "worktree"` (or `git worktree add ../<repo>-<task> -b work/<task>`). Never two writers in one checkout. Read-only scouts can share yours.
- **At most `MAX_PARALLEL` writers** (`core.env`). More is slower: they fight for the machine and you cannot review them.
- **Brief each worker completely**: goal, files it may touch, the command that proves it, "commit on your branch, do not push, do not run the full gate". It knows nothing you do not tell it.
- **Record what is in flight** in `run/STATE.md` (`- [~] task — branch, worktree`) before you launch, so a cold start can find or discard it.
- **Shared things go through one hand.** Files every task appends to (route lists, migration numbers, translation files, lockfiles, indexes) are edited by the lead at integration, not by workers. Shared resources (test database, ports, devices) are used through `sh scripts/lock.sh <name> <command>`.
- **Integrate one branch at a time**: read the diff, merge into the run branch, run `sh scripts/verify.sh`, fix or revert before taking the next. A worker's report is a claim; the diff and the gate are the facts.
- **Leave nothing behind**: remove merged worktrees and branches before the session ends. An unfinished one stays listed in `run/STATE.md` with what is left.

## Never stop to ask

Nobody will answer. When you hit a question, choose the answer you would recommend, write it in `run/INBOX.md` with the default you took and how to undo it, and keep going. If the question touches the plan's **Never break** or **Must wait** lists, park that task and take another. `blocked` is only for when nothing else is left.

## Proof

- Commit each working step. Uncommitted work is lost when the context resets.
- "Done" means the plan's check ran and passed, and the journal shows the command and its result. `sh scripts/verify.sh` is the gate; the loop runs it itself and does not take your word.
- Never weaken, skip or delete a test or the gate to go green. If a check is wrong, say so in the inbox and leave it failing.
- Say plainly what you did not run or could not verify. An honest gap is useful; a hidden one costs the owner a day.

## Hard limits (hooks enforce most of them)

- Work only on the run branch and branches cut from it. Never commit, push or merge to a protected branch; never force-push; never delete unmerged work that is not yours.
- `PLAN.md`, `core.env` and this file belong to the owner. Propose changes in the inbox.
- No secrets in files, prompts, logs or command lines. Never read `.env` or secret stores into the conversation.
- Local and dev data only. Nothing production, paid or outward-facing (messages, publishing, deploys) unless the plan's **May do alone** says so.
- Do not install system software or add a paid service. A new dependency is fine when it is free, maintained and recorded in decisions.

## Style

Smallest change that passes the check. Write short and plain, answer first.

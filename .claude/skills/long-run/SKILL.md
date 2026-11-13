---
name: long-run
description: Run a long, multi-slice or overnight task so it survives context loss, stuck tests, tool limits and the owner being away, and can be picked up on another machine. Use when the owner says "keep working", "overnight", "see you tomorrow", "long running", "continue until done", or when a task will outlast one context window. Pairs with orchestrate (workers), checkpoint (state files) and monitor (visibility).
---

# long-run: stay correct for hours, not just fast

Rules stay in `AGENTS.md`. Worker routing and the merge loop: `orchestrate`. State files: `checkpoint`. This skill is only about surviving a long run.

## 1. Before you start (2 minutes)

- Read STATUS, the active brief, the ledger, `git worktree list`, open PRs. Never work from memory of an earlier context.
- `sh scripts/core/doctor.sh` (disk, tools, caps, dirty tree). Fix FAILs first.
- Write the **run contract** as the first ledger entry ([template](../../../docs/templates/ledger.md)): goal, queue in order with a finish line each, what you may do alone, what waits for the owner, facts a cold start needs, the do-not list, and **Next action** (one line, kept current).
- Never edit a checkout holding someone else's WIP; use a worktree.

## 2. Work in small, saved steps

- One slice at a time per set of files; commit on the work branch at each green step.
- After every merged slice: `scripts/core/ledger.sh` line, then STATUS/PROGRESS if state changed, and refresh **Next action**.
- A builder that hits its output limit: resume with "small steps, one file per tool call".
- Treat reports as claims: read the diff, rerun the focused gate yourself.

## 3. Testing without stalling

- Focused gate per slice; whole suite only for promotions, shared infrastructure, or on request.
- Long commands run in the background; wait for the completion notice. Never poll or sleep-loop.
- A timeout hitting many tests at the same instant is a machine stall, not a code bug: rerun those alone.
- Same failure twice for the same reason: stop, read it, fix or record it. Never loosen a test.
- Shared resources (test database, ports, device) get a lock: `mkdir <lockdir>` before, `rmdir` after.

## 4. Decisions while the owner is away

- Decide the recommended answer and keep going unless money, security or scope changes. Ledger line; if it binds others, an ADR marked Proposed (`record-decision`).
- Questions go to `docs/open-questions.md` with a recommendation. Take the next independent slice; never block.
- Never: push to protected branches, force-push, delete unmerged work, touch production data, put a secret on a command line, enable a switch that changes real behaviour for users.

## 5. Context loss and handoff

The summary after compaction is lossy; make the repo the memory.

- Ledger + STATUS + brief must be enough for a cold start. **Next action** is the first thing in the ledger.
- Durable lessons go to a skill or ADR; personal preferences to the assistant's memory; not STATUS.
- At ~70% context or before a long wait: finish or commit the step, update the ledger, then continue. Do not start a big read at the end of a window.
- Leaving or moving machines: merge or park every branch, remove finished worktrees, drop test databases and temp credential files, say what stays local. See skill `handoff`.

## 6. End-of-run report (short, answer first)

1. What merged (PRs) and what did not.
2. What was not run or verified, plainly.
3. What waits for the owner, each with a recommendation.
4. Where everything is: branches, worktrees, data state.
Finish with `/checkpoint save`.

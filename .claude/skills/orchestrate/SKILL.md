---
name: orchestrate
description: Run work autonomously as an orchestrator that splits a goal into slices, gives each to a worker (Claude subagents or CLI, Cursor CLI, any agent CLI) in its own git worktree, gates the result with local tests, reviews by risk, merges, cleans up and keeps the ledger. Use when the owner says "work autonomously", "run in parallel", "weekend mode", "use Cursor and Claude together", or asks to continue the plan unattended.
---

# orchestrate: autonomous multi-worker delivery

Rules stay in `AGENTS.md`. Who does what: [models.md](models.md). Cleanup: [cleanup.md](cleanup.md). Queue runner: `scripts/core/queue-runner.sh`. CLI details: skills `claude-cli`, `cursor-cli`. Surviving hours: skill `long-run`.

The orchestrator plans, routes, gates, merges, cleans and records. It does not build big things itself. It may be Claude (own workers via the Agent tool, other vendor via CLI) or Cursor (own subagents, Claude via `claude -p`).

## The loop

1. **Orient.** `docs/STATUS.md`, active brief, ledger (run contract + next action), `git worktree list`, open PRs. `sh scripts/core/doctor.sh`.
2. **Cut.** Split into slices that touch different files (skill `plan`). Two writers never share files. Shared lists (route tables, schema ledgers, translation files, fakes, index files) conflict: merge those slices one after another, or let the later one merge the base and keep both sides.
3. **Route.** Pick the worker from models.md. Anything touching an invariant: a strong builder, then a strong review before merge.
4. **Worktree.** `sh scripts/core/worktree-new.sh <type>/<name>`. Queue files and logs live outside the repo (`CORE_QUEUE_DIR`), never in a scratch dir that can be cleaned.
5. **Brief.** One self-contained prompt per worker: goal, files and skills to read, finish-line command, commit message and trailer, "do not push", "do not run other slices' suites", what to report. Template: [worker-brief.md](worker-brief.md).
6. **Launch.** Claude workers: Agent tool, background, explicit `model`. Other CLIs: queue runner (detached, sequential, logged) or one headless run in a terminal tab the user can watch. Never poll; a completion notice wakes you. A launcher shell exiting is not the worker finishing: read the log.
7. **Gate.** The stack's focused gate (`backend`/`frontend`/`testing` skills) on the worktree: 0 failures, analyzer/linter clean. Whole suite only for promotions to a release branch, shared infrastructure, or on request. Same test failing twice for the same reason: stop retrying, read it.
8. **Review.** Invariant-touching diffs go to `reviewer` before merge. Fix must-fix and should-fix, rerun the gate.
9. **Merge.** The orchestrator pushes (workers do not). Merge the base into the branch (conflicts: keep both sides, regenerate generated files, rerun the gate if shared files moved), push once, open the PR, squash-merge when green and no open must-fix, then `sh scripts/core/worktree-done.sh <branch>`. Never touch protected branches except through PRs. Merge mode: `CORE_MERGE_MODE`.
10. **Cleanup, ledger, status.** Run the cleanup pass; `sh scripts/core/ledger.sh "<slice> / <worker> / <gate> / <outcome>"`; update STATUS and PROGRESS (`/checkpoint save`); next slice.

## Unattended mode

Write the queue to `CORE_QUEUE_DIR`, run sequentially, auto-merge only slices whose risk class is low and whose gate is green; leave invariant-touching slices on their branch for review (or run them with the strongest builder and reviewer if the run contract grants it). Keep the handoff in the ledger: what is queued, what waits for review, what failed and why. When one vendor's limit is low, route small tasks to the other.

## Lessons (do not repeat)

- A worker's report is a claim: check the diff and the gate yourself.
- macOS has no `timeout`: `perl -e 'alarm shift; exec @ARGV' 5400 cmd`.
- Wait loops: match the real process, not a path it was not started with.
- Long headless turns that run big suites lose the connection: keep worker tasks under ~30-90 minutes and run suites in the gate, outside the turn.
- Run heavy suites one at a time; parallel suites on one database time out and collide. Never `pkill` test hosts: it kills other workers' runs.
- Squash merges look "ahead": compare content with the base, not commit counts.
- Rejected experiments get a ledger line before deletion.

# Lessons from long runs (do not repeat)

Distilled from two projects: a multi-tenant platform delivered by an orchestrator over many unattended nights (100+ merged PRs), and a desktop app released across three operating systems. Stack-specific ones live in the stack fragments.

## Process

- **Make the repo the memory.** The summary after context compaction is lossy. The ledger's Next action + STATUS + brief let a cold start continue. Update them at every merged slice.
- **Docs bloat silently.** Caps (STATUS 40 lines/3 KB, skills 6 KB, rules 90 lines) and a doctor script keep them readable. One fact, one file, link to it.
- **Commit at each green step.** An uncommitted step does not exist after a crash.
- **A worker's report is a claim.** Read the diff, rerun the focused gate.
- **Ask-first lists beat blanket permission.** Pre-grant narrow standing authority in the run contract (merge slice PRs after a green gate and review; never protected branches); everything else waits and the run continues on the next slice.
- **Decide the recommended answer and keep going**, unless money, security or scope changes. Park the question with a recommendation; never block.
- **Review by risk, not by volume.** A stronger reviewer on invariant-touching diffs found real races, leaks and oracles that green tests missed (an audit before-value race, a retry fingerprint, a link-existence oracle). Several review rounds on money slices were normal and worth it.
- **Pick workers by evidence.** Record which model did well on which task; measure wall time before believing "faster" (a split test suite showed no gain).

## Parallel work

- Two writers never share files. Shared lists (routes, schema ledgers, translation files, fakes, indexes, ADR index, open-questions) conflict: merge such slices one after another, keep both sides, renumber colliding ADRs and migrations.
- Squash merges look "ahead": compare content with the base, not commit counts, before deleting a branch.
- One worktree per worker; queue files and logs live outside the repo and outside any scratch dir that can be cleaned.
- Do not `pkill` test hosts: you kill other workers' runs. Stop only your own process.

## Tests and gates

- Focused gate per slice (tests for what changed); the whole suite only for promotions, shared infrastructure or on request. Hosted CI may be off for cost: the local gate is then the evidence, and you say so.
- Heavy suites one at a time; parallel suites on one database time out and collide. Lock shared resources (`mkdir lockdir`).
- Many tests timing out at the same instant is a machine stall (for example a fork deadlock), not a code bug: rerun them alone.
- Same failure twice for the same reason: stop retrying; read it.
- A skipped database test is not a pass.

## Long headless runs

- `-p` runs lose the connection on very long turns: keep worker tasks under ~30-90 minutes, run big suites in the gate, outside the turn.
- macOS has no `timeout`: use `perl -e 'alarm shift; exec @ARGV' SECONDS cmd`.
- Wait loops must match the real process. A launcher shell exiting is not the worker finishing: read the log.
- A builder that hits its output limit: resume in small steps, one file per tool call; do not restart.
- When one vendor's usage limit is low, route small tasks to the other.

## Data and safety

- Agents use only the local dev database, through wrapper scripts; read-only wrapper for inspection; no passwords on command lines; temp credential files deleted after use.
- Editing a migration before merge leaves dev databases with an "edited" warning: reset the dev database.
- Seed data must rebuild the full test world, so a fresh machine is one command away.
- Money exact, tenant isolation backed by the database, append-only audit: make each an invariant with a test.

## Delivery

- Each OS builds only its own installers, on that OS; upload to one draft release; publish only when all are present, after human confirmation.
- Keep a hardware / real-user checklist for what tests cannot cover; record diagnostics when a step fails.
- Idle cost is a feature: refresh on demand, not by reacting to everything. Measure before and after (CPU, memory, wakeups).
- Signing keys and tokens never go in public repos, chat or command lines.

## Hygiene

- Cleanup pass after every batch: merged worktrees and branches, stray files saved as a patch then dropped, test databases, temp credential files, build output, compact merged briefs.
- Never `git stash -u` or `git checkout --theirs .` in a shared checkout.
- Files out of place go to their path (queue files outside the repo, scripts in `scripts/`, notes in `docs/`).

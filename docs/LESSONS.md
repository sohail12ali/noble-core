# Lessons from long runs (do not repeat)

Earned in real unattended runs. Agents: read the part that matches what you are doing, and add a dated line when something costs you time. Keep lines that would have saved an hour; delete ones that models no longer need.

## Process

- **Make the repo the memory.** The summary after context compaction is lossy. `run/STATE.md` and the journal let a cold start continue. Update them before every session ends.
- **Docs bloat silently.** One fact, one file. State files describe now; history goes in the journal.
- **Commit at each green step.** An uncommitted step does not exist after a crash.
- **A worker's report is a claim.** Read the diff, rerun the focused gate.
- **Narrow standing authority beats blanket permission.** The plan lists what may be done alone; everything else is parked in the inbox and the run continues.
- **Decide the recommended answer and keep going**, unless money, security or scope changes. Park the question with a recommendation; never block.
- **Review by risk, not by volume.** A stronger reviewer on invariant-touching diffs found real races, leaks and oracles that green tests missed (an audit before-value race, a retry fingerprint, a link-existence oracle). Several review rounds on money changes were normal and worth it.
- **Measure before believing "faster".** A test-suite split that looked like an obvious win showed no wall-time gain.

## Parallel work

- Two writers never share files. Shared lists (routes, schema ledgers, translation files, fakes, indexes, ADR index, open-questions) conflict: merge such work one after another, keep both sides, renumber colliding ADRs and migrations.
- Squash merges look "ahead": compare content with the base, not commit counts, before deleting a branch.
- One worktree per worker; queue files and logs live outside the repo and outside any scratch dir that can be cleaned.
- Do not `pkill` test hosts: you kill other workers' runs. Stop only your own process.

## Tests and gates

- Focused gate while building (tests for what changed); the whole suite only for promotions, shared infrastructure or on request. Hosted CI may be off for cost: the local gate is then the evidence, and you say so.
- Heavy suites one at a time; parallel suites on one database time out and collide. Lock shared resources (`mkdir lockdir`).
- Many tests timing out at the same instant is a machine stall (for example a fork deadlock), not a code bug: rerun them alone.
- Same failure twice for the same reason: stop retrying; read it.
- A skipped database test is not a pass.

## Long headless runs

- `-p` runs lose the connection on very long turns: keep one session's work bounded, run big suites in the gate, outside the turn.
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

- Clean up after yourself before the session ends: finished worktrees and branches, test databases, temp credential files, build output.
- Never `git stash -u` or `git checkout --theirs .` in a shared checkout.
- Files out of place go to their path (queue files outside the repo, scripts in `scripts/`, notes in `docs/`).

## Stack notes (earned, not general advice)

- **.NET:** xUnit v3 on Microsoft.Testing.Platform needs `dotnet test --solution` or `--project`. Several `--filter-namespace` flags OR together; mixing class and namespace filters ANDs to zero tests. Clearing the NuGet cache breaks test-runner resolution: restore and rebuild.
- **Flutter:** generated localization files and shared registries conflict across parallel work: merge one after another and regenerate. Run package test suites one process at a time. Find widgets by semantics or keys, never translated text.
- **PostgreSQL:** row-level security must be enabled *and forced*; revoke update/delete on append-only tables in the migration that creates them. `CREATE INDEX CONCURRENTLY` cannot run in a transaction. Parallel suites on one server fail on `DROP DATABASE`.
- **Desktop releases:** each OS builds only its own installers on that OS, into one draft release; a person publishes when all are present.

# Model routing

Set the model explicitly on every worker. This is a starting table: edit the right-hand column with your own evidence (date it) and re-measure when models change. Judge by measured wall time and first-pass gate results, not by effort level.

| Task | Worker (default) | Why |
|---|---|---|
| Design briefs, slice cuts, ADRs, architecture, conflict resolution on shared files | strongest Claude model (`planner`), fallback Opus | judgement work |
| Review of invariant-touching diffs (money, privacy, tenancy, auth, safety) | strongest Claude model (`reviewer`), fallback Opus | catches races, leaks, oracles builders miss |
| UI, screens, layout, copy for screens | Claude Opus builder | visual and accessibility judgement |
| Backend slices, SQL migrations, DB-backed tests | Claude Sonnet builder | reliable on bounded, testable work |
| Invariant-touching backend slices | Claude Opus builder, then strong review | |
| Lookups, version checks, file moves, consistency scans, cleanup inventories, doc compaction | Claude Haiku `scout` | cheap, read-mostly |
| Self-contained app or docs chore with a clear finish line, under ~30 min | Cursor large model (high effort) | parallel capacity, separate usage limit |
| Quick mechanical edits, renames, formatting | Cursor fast model | speed |

Do not give another vendor's headless worker: invariant-touching slices unattended, schema migrations, or anything whose gate takes hours.

When the orchestrator is Cursor, map the same table: strong/mid/cheap Claude work goes to `claude -p --model opus|sonnet|haiku`; Cursor-native work stays native.

## Evidence log (append, date each)

| Date | Observation | Change made |
|---|---|---|

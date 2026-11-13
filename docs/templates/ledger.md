# Run ledger

## RUN CONTRACT {YYYY-MM-DD} ({day|night|weekend}; owner away | present)

**Next action:** {one concrete line; keep this line current. It is what a cold start reads first.}
**Goal:** {what this run delivers}
**Queue (in order, each with its finish line):**
1. {slice} - `{finish-line command}`
**Standing authority:** {e.g. squash-merge slice PRs into the base branch after the local gate is green and must-fixes are done; docs-only PRs too; never protected branches by force}
**Waits for the owner:** {rule changes, new dependencies, production, money, secrets}
**Facts:** {local ports, db version, locks, anything a cold start would otherwise rediscover}
**Do not:** {push to protected branches, force-push, delete unmerged work, put secrets on a command line, ...}

## {YYYY-MM-DD}

- {slice} / {worker + model} / {gate result} / {outcome: merged PR | left on branch | rejected, why}

---
name: database
description: Write and review versioned schema scripts, seed data, grants, isolation policies and backups; keep a schema ledger; protect data. Layer 0 gives engine-free principles; once a stack profile exists this skill is re-rendered with the engine's commands and conventions. Use whenever a task adds or changes tables, columns, indexes, policies, grants, SQL or data scripts, or asks what version the database is at.
---

# database


## Principles

- **Source of truth is versioned scripts in the repo**, forward-only, numbered, applied by a runner that records checksums. Never edit a merged migration; fix with a new file. A changed checksum should fail the runner.
- **Layout:** `db/migrations/` (numbered), `db/setup/` (one time, run by a human with the privileged role; agents never enter superuser credentials), `db/seed/` (dev and test data only, rebuilds a full test world, never run in production), `db/SCHEMA.md` (ledger: version | change | slice | date, updated in the same PR).
- **Naming:** one rule, enforced by a test (for example lowercase snake_case, never quoted; plural tables, `<singular>_id` foreign keys, `<event>_at` timestamps, `is_`/`has_` booleans, `pk_ fk_ uq_ ix_ ck_` constraint prefixes).
- **Money** as integer minor units plus currency code; never floating point.
- **Isolation:** if data belongs to tenants/owners, every row carries the owner id, queries filter by it, and the database enforces it as a backstop (row-level policies or equivalent). A test proves one tenant cannot read or write another's rows, with and without the ORM filter.
- **Append-only** for financial and audit tables: revoke update/delete from the application role in the same migration; corrections are new rows.
- **Constraints live in the database** (check, foreign key, unique), not only in code.
- **Destructive changes** (drop, rename, type change): expand, backfill, switch code, contract in a later migration. Never drop in the same release as the code change.
- **One concern per migration**, header comment: what, why, slice, ADR. One transaction per file unless the engine forbids it (say so in the header).
- **Secrets:** never in scripts; setup scripts take passwords as variables; no passwords on command lines.
- **Agents touch only the local dev database**, through the project's wrapper scripts (changes) and a read-only wrapper (inspection). Never production or real data.
- **Backups/saving data:** know how to snapshot and restore the dev database; production backup and restore are in the delivery plan and rehearsed.

## Adding a migration

1. Design in the slice brief (before/after, indexes, isolation, grants).
2. Write the numbered script. Number = highest + 1 (renumber colliding ones at merge).
3. Update `db/SCHEMA.md`.
4. Apply to the dev database, run the isolation and grant tests.
5. Align the data-access model; the model-versus-schema test must pass.

<!-- stack:begin -->
## Stack

Not defined (layer 0). Layer 1 adds `scripts/core/apply_stack.py`, which fills this section from `stack/profile.env`: the stack's conventions, pitfalls and exact commands.
<!-- stack:end -->

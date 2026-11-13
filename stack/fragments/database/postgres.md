**Engine and roles:** PostgreSQL (pin the major version). Three roles: an owner/migration role (CREATEDB locally, used by the runner and tests), an application runtime role (USAGE on schemas, never CREATE), and a read-only role for inspection. A human runs `db/setup/*.sql` once as superuser; agents never enter superuser or any password on a command line (use `~/.pgpass` or a secret store, and delete temp passfiles after a run).

**Conventions:**

- One schema per module (`CREATE SCHEMA x; GRANT USAGE ON SCHEMA x TO app;`), `public` holds only the migration ledger. Qualify every object. Names are lowercase snake_case, never quoted, at most 63 chars.
- Types: `uuid` keys, `timestamptz`, dates as `date` (half-open ranges), money `bigint` `<name>_minor` plus `currency char(3)`, status as `text` plus a named check constraint (no enum types).
- Tenant tables: `tenant_id uuid not null` (first column of composite indexes), RLS enabled **and forced**, one policy on `current_setting('app.tenant_id', true)::uuid`:

```sql
alter table x.things enable row level security;
alter table x.things force row level security;
create policy tenant_isolation on x.things
  using (tenant_id = current_setting('app.tenant_id', true)::uuid)
  with check (tenant_id = current_setting('app.tenant_id', true)::uuid);
```

- Append-only tables: `revoke update, delete, truncate on x.ledger from app;` in the same migration that creates it.
- Data-access layer sets `app.tenant_id` per request/transaction (`set_config(..., true)`).

**Pitfalls:**

- `CREATE INDEX CONCURRENTLY` cannot run in a transaction: say so in the header or avoid it.
- Editing a migration before merge leaves dev databases with an "edited" checksum warning: reset the dev database.
- Test databases are unique per run (`app_test_<id>`) and dropped after; leftovers are cleaned only when no suite runs.
- Parallel suites on one server can fail on `DROP DATABASE`; run heavy suites sequentially, or lock.

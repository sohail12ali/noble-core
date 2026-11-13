# Invariants

Rules that must never break. Each has an owner test or a reviewer checklist line. Breaking one needs an ADR approved by the owner. Copy to `docs/INVARIANTS.md` and fill in.

| # | Invariant | Enforced by (test / constraint / review item) |
|---|---|---|
| 1 | {e.g. money is exact: integer minor units, never float} | {architecture test} |
| 2 | {e.g. each tenant's data is separate: tenant id on every row, row-level security} | {isolation test} |
| 3 | {e.g. every financial action writes an append-only audit record} | {grant test} |

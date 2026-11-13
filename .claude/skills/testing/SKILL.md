---
name: testing
description: How to write, run and review tests across layers - unit, integration on a real data store, architecture, client, end to end - what a slice must prove to close, and how to gate merges without stalling. Use when adding or changing any test, diagnosing a failing test, choosing the gate, or closing a slice.
---

# testing

Commands come from the stack profile (`TEST_CMD`, `TEST_CHANGED_CMD`, `TEST_ALL_CMD`) once layer 1+ is applied.

## Layers

| Layer | Covers | Data store |
|---|---|---|
| Unit | pure domain rules, table-driven with edge cases (month ends, leap days, boundaries, mixed currency) | none |
| Integration | API, roles, isolation, audit, grants, model vs schema | real engine, a unique throwaway database per run |
| Architecture | dependency direction, banned types (floating money), layering | none |
| Client unit/widget | formatting, state logic, critical flows | none; fake the API at the repository boundary |
| End to end | a few critical flows against a local backend | local |
| Hardware / real-user checklist | what automation cannot show | manual, numbered steps with expected results |

## Rules

- **Rules first:** every business-rule check in a brief becomes a failing test, then code.
- **No mocking the database.** Create a uniquely named database per run, apply all migrations, drop it after. Connection strings from env or a secret store, never the repo.
- **Every endpoint:** happy path, wrong role, other tenant returns not-found, validation failure; financial ones assert the audit record.
- **Time and randomness** are injected; no sleeps, no system clock.
- **Never** skip, delete or loosen a test to pass; fix the code or ask. Flaky means broken: find the cause. A skipped test is not a pass: closing a slice needs the data-store tests actually run.
- Name tests by behavior (`Renewal_before_expiry_starts_after_current_coverage`).
- Tests over ~2 minutes are bugs: split or speed up.

## Gates (use the cheapest that proves the change)

1. **While building:** the focused tests for the files touched, plus the analyzer/linter.
2. **Merge gate:** a "tests for what changed" command that maps the diff to affected suites (unit + architecture + only the affected integration areas).
3. **Full suite:** promotions to a release branch, shared-infrastructure changes, or on request.

Heavy suites run one at a time, with a lock around shared resources. Timeouts hitting many tests at the same instant are a machine stall: rerun those alone. Same failure twice: stop retrying, read it.

## Slice close needs

Finish-line command passing, the suites for what changed, the invariant review against the diff, evidence pasted into the brief, and a plain statement of what was not run.

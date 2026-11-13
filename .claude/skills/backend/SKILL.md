---
name: backend
description: Write and review server-side code - APIs, domain logic, background jobs, ports to outside services. Layer 0 gives stack-free principles; once a stack profile exists this skill is re-rendered with the stack's commands and conventions. Use for any task in the server code.
---

# backend

Stack: not defined (layer 0). Layer 1 adds `scripts/core/apply_stack.py`, which re-renders this file from a stack profile.

## Principles

- **Domain first.** Business rules live in pure code with no I/O, tested table-driven with edge cases before any wiring.
- **Trust boundaries validate.** Every input from a client, queue or outside service is validated; every endpoint checks authentication and authorization; deny by default.
- **Ports and fakes.** Outside services (email, SMS, payments, storage) sit behind an interface with a dev fake; swapping providers touches one adapter. Dev-only routes exist only in the development environment, and a test proves it.
- **Money and time.** Money is exact (integer minor units plus currency). Time comes from an injected clock, never the system clock directly. Randomness and ids are injected or fixed in tests.
- **Idempotency.** Anything a client may retry (payments, creates) takes an idempotency key.
- **Audit.** Security- or money-relevant actions write an append-only record in the same transaction.
- **Errors.** Typed results at module edges; never swallow an error that could lose data; no secrets or personal data in logs.
- **Small modules.** One responsibility each, dependencies point inward; an architecture test fails on a wrong-direction reference.
- **Dependencies** only from the stack baseline; a new one needs an ADR.

## Per endpoint tests

Happy path, wrong role, other tenant's data returns not-found, validation failure; financial or audit-relevant endpoints also assert the audit record.

## Commands

Defined by the stack profile: `BUILD_CMD`, `TEST_CMD`, `LINT_CMD`, `RUN_CMD` (see `stack/profile.env`).

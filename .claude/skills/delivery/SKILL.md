---
name: delivery
description: Plan and run delivery - environments, versioning, packaging, release, rollout, rollback and post-release verification, including builds that must run per operating system and checks only real hardware can do. Use when preparing a release, writing the delivery plan, setting up a pipeline or deciding how to roll out and roll back.
---

# delivery

Plan lives in `docs/plan/delivery.md` (template `docs/templates/PLAN-delivery.md`). Decisions as ADRs.

## Principles

- **One command per step**, documented in the delivery plan: test, build, package, publish, verify. If a step needs a human (signing, store review, publish), the plan says who and how.
- **Local gate is the evidence** when hosted CI is unavailable or off; use CI when it is on. Say which one proved the release.
- **Per-OS builds** run on that OS only (no cross-building) and upload to one draft release; the release is published only after every OS is present, by a human-confirmed step.
- **Versioning:** one source of truth for the version, checked by a script before building; changelog entry per release; tag after publish.
- **Rollout:** staged exposure and feature switches for risky behaviour; switches that change real behaviour for users are the owner's call.
- **Rollback:** code (previous artifact) and data (forward-only migrations, expand then contract; never drop in the same release as the code change). State the rollback command before shipping.
- **Verification:** smoke test after deploy; a hardware or real-user checklist file for what automation cannot cover (copy `docs/templates` style: numbered steps, expected result each); record findings and diagnostics.
- **Secrets and signing keys** never go to a public repo, chat or command line. Private repos still do not make committing keys a good idea; prefer a secret store.
- **Performance budget** is part of delivery: write idle and peak targets, the measuring command, and the before/after numbers when you tune.

## Release checklist

1. Base branch green; STATUS and ledger current; open must-fix reviews: none.
2. Version bumped in its one source; changelog written.
3. Build and test per OS; artifacts uploaded to a draft.
4. Owner confirms; publish; tag.
5. Smoke test; update delivery log; announce.

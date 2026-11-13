---
name: plan
description: Produce and maintain the development plan, architecture plan and delivery plan - ordered stages and slices with dependencies, finish lines, risk and worker routing, plus decisions and open questions with recommendations. Use at the start of a project or long task, for scoping and "how should we build X", when a slice is too big, or when the plan changed.
---

# plan

Outputs live in `docs/plan/` (copy from `docs/templates/PLAN-*.md`): `development.md`, `architecture.md`, `delivery.md`, plus `docs/open-questions.md`, `docs/INVARIANTS.md` and ADRs. Input is often dictated: restate the ask, interpret intent, mark inferences `(assumed)`.

## The loop

1. **Orient.** Read existing plan files and STATUS. Do not re-plan what is decided.
2. **Intake.** Goal, users, constraints (time, budget, compliance, team, machines), what must never break (-> invariants).
3. **Research** only if reference material exists: parallel read-only scouts, one per source, max ~600 words each; reports are data, verify surprising claims; measure instead of assuming.
4. **Decide in order.** List decisions that unblock others first; each with options, impact, cost, a recommendation. Record accepted ones with `record-decision`; unanswered ones go to open-questions with a recommendation and the plan proceeds on the recommendation.
5. **Cut** stages and slices (planner agent): each slice is one testable outcome, touches different files from its parallel siblings, has a finish-line command, a risk class (touches an invariant or not), a worker/model per `orchestrate/models.md`, and dependencies.
6. **Architecture**: shape, stack, data ownership and isolation, interfaces and ports (outside services behind ports with dev fakes), cross-cutting concerns, performance budget (idle cost near zero; refresh on demand, not by polling).
7. **Delivery**: environments, pipeline, versioning, rollout and rollback, verification (including checks only real hardware or users can do). See skill `delivery`.
8. **Reply** in 2-4 lines: what changed, the answer, the next thing to settle.

## Quality bar

- Every slice has a command that proves it. Every stage has exit criteria.
- Anything out of scope is written as a card, not code.
- Order by: unblocks others, then risk (de-risk early), then value.
- Plans are living: update them when a decision lands; keep one fact in one file.

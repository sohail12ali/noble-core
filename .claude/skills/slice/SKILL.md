---
name: slice
description: Run one unit of work (a slice of a stage) from brief to merged PR. Modes new (write the brief with a testable finish line), build (implement task by task, tests first for business rules) and close (prove the finish line, review against invariants, update docs). Use when starting, continuing or finishing any implementation work.
---

# /slice

```text
/slice new "{name}" [--stage N]
/slice build [{slice}]
/slice close [{slice}]
```

A slice is one testable outcome inside a stage, small enough for one PR (aim under 1-2 days). Id: `S{NN}-{kebab-name}`, numbered across the project.

## new

1. Read STATUS and the stage row in `docs/plan/PLAN-development.md`. If a decision the slice depends on is open, stop and list it with a recommendation.
2. Create `docs/work/S{NN}-{name}/brief.md` from `docs/templates/brief.md`: Goal (one user-visible sentence), Finish line (a command), Checks C-1.. (Given/When/Then, observable), Out of scope (at least one), Data changes (design before migrating), Tasks (ordered, each one layer, each traced to a check).
3. Branch from the up-to-date base: `sh scripts/core/worktree-new.sh feature/S{NN}-{name}`.
4. Point STATUS at the slice (3 lines).

## build

1. Load the matching skills (`backend`, `frontend`, `database`, `testing`).
2. Per task: failing test first for business rules, then the smallest code, then wiring. Look up version-sensitive APIs in current docs, not memory. Run the focused gate; tick the task.
3. A design choice others must follow: `/record-decision`. A question for the owner: `docs/open-questions.md` with a recommendation; continue with other tasks.
4. Scope grows: write a new card or follow-up slice; do not absorb it.

**Pace:** ship in big checked chunks (one branch and PR per stage chunk, tasks are commits); focused tests while building, the focused merge gate before the PR; tests over ~2 minutes are bugs; review by risk.

## close

1. **Finish line:** run it; paste command and result into the brief's Evidence. Failing means not closed.
2. **Full checks** for the parts touched and what depends on them.
3. **Invariant review:** `reviewer` against `git diff <base>...HEAD`. Every item pass or n/a; anything else is a bug to fix now.
4. **Simplify:** remove dead code, unused abstractions, debug output.
5. **Docs:** durable knowledge into a skill or ADR. After merge compact the brief to ~15 lines and delete notes. `/checkpoint save`.
6. PR body: goal, finish-line evidence, checks table, data changes, risks. The slice is `done` once merged.

## Rules

No code without a brief; no brief without a finish line. Never weaken or skip a test to pass; fix the code or ask.

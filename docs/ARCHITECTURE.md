# How it fits together

## Roles

| Role | Does | Does not |
|---|---|---|
| **Owner** | sets goals, answers questions, grants standing authority in the run contract, approves rule changes | review every diff |
| **Orchestrator** (any strong agent session) | orients, cuts slices, routes workers, briefs, gates, reviews by risk, merges, cleans, records | build large things itself |
| **Workers** (`builder`, Cursor/Claude CLI runs) | implement one slice task in one worktree | push, merge, touch other slices' files |
| **Scout** | cheap read-only lookups and inventories | edit anything |
| **Reviewer** | invariant checklist + security pass on a diff | edit anything |
| **Planner** | development/architecture/delivery plans | write code |

## State (everything a cold start needs)

| File | Holds | Size rule |
|---|---|---|
| `AGENTS.md` | rules | < 90 lines |
| `docs/STATUS.md` | now / last done / next / waiting | 40 lines, 3 KB |
| `docs/PROGRESS.md` | stage table | one line per stage |
| `docs/work/<slice>/brief.md` | goal, finish line, checks, tasks, evidence | compact to ~15 lines after merge |
| `.autonomous/ledger.md` | run contract, **Next action**, dated outcome lines | append-only |
| `docs/decisions/` | ADRs | one decision each |
| `docs/open-questions.md` | questions with recommendations | never blocks |
| `docs/plan/` | development, architecture, delivery plans | living |
| `docs/INVARIANTS.md` | never-break rules + how each is enforced | short |

## The run loop

See `.claude/skills/orchestrate/SKILL.md` (loop), `long-run` (surviving hours), `monitor` (visibility), `handoff` (moving), `delivery` (shipping).

## Enforcement, not hope

| Concern | Mechanism |
|---|---|
| Nobody commits to protected branches / badly named branches | `scripts/hooks/block-protected-branch-commit.sh` as a Claude `PreToolUse` hook |
| Docs stay light | `scripts/core/doctor.sh` checks STATUS and skill size caps |
| Worktrees do not leak | `worktree-new.sh` / `worktree-done.sh` (content comparison, refuses unmerged work) |
| Cold-start safety | ledger "Next action", `snapshot.sh` |
| Unattended queue | `queue-runner.sh`: worktree -> worker -> gate -> merge only if green |
| Secrets | deny rules for env and secrets paths; rule 6 |

## Extending

New skill: `.claude/skills/<name>/SKILL.md` with `name` and a `description` that says when to use it (that line is what makes an agent load it). Keep it under 6 KB; move examples to sub-files. Add it to the Cursor rule table.

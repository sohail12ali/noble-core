# Agent rules (core)

One source of truth for every agent (Claude Code, Cursor, others). `CLAUDE.md` and `.cursor/rules/core.mdc` only point here. Rules live here; how-to lives in skills (`.claude/skills/<name>/SKILL.md`). Keep this file under 90 lines.

## Start of every session

1. Read `docs/STATUS.md`. If a slice is active, read its `docs/work/<slice>/brief.md`. Nothing else until the task needs it.
2. Long or unattended work: also `.autonomous/ledger.md` (the run contract and next action) and `git worktree list`.
3. Load a skill only when the task matches its description.
4. End with `/checkpoint save`.

## Non-negotiable rules

Project-specific invariants (money, privacy, tenancy, safety) are listed in `docs/INVARIANTS.md` once the project has them; each has a test or a review checklist item. Breaking one needs a decision record approved by the owner.

1. **The repo is the memory.** Anything needed after a crash or a context reset is in a file: ledger, STATUS, brief, ADR. A step that is not committed does not exist.
2. **Evidence over claims.** A worker's report is a claim. Read the diff and run the gate yourself. Say plainly what was not run.
3. **No code without a brief; no brief without a finish line** (a command or demo that proves it). Never weaken or skip a test to go green.
4. **Isolation.** One worktree per worker, never two writers on the same files. Never edit a checkout that holds someone else's work.
5. **Protected branches change only through PRs.** Never commit or push to them, never force-push, never delete unmerged work (a hook blocks the first two).
6. **No secrets in code, docs, prompts, logs or command lines.** Secrets live in the user's secret store or untracked env files. Agents touch only local or dev data stores, never production.
7. **Decisions are written down** (ADR) with the alternatives rejected. A decision made while the owner is away is marked `Proposed` until they agree.

## Autonomy

- **Act freely** on a work branch: code, tests, local database, ADRs, docs, worktrees, local gates.
- **Ask first** (or hold the item and continue with the next one when unattended): pushing and PRs unless standing approval is in the run contract; merging into a protected branch; deleting files outside the task; adding a dependency outside the baseline; installing software; anything non-local, paid, production or involving secrets; changing a rule above; more than ~10 files outside the slice.
- Decide the recommended answer and keep going unless money, security or scope changes. Every question to the owner carries a recommendation and goes to `docs/open-questions.md`; never block on it, take the next independent slice.
- Smallest change that meets the finish line. No speculative abstractions. Mark a deliberate shortcut `shortcut: {limit}, {when to upgrade}`.
- Never cut input validation at trust boundaries, data-loss handling, security or accessibility.

## Delegation

The orchestrator plans, routes, gates, merges, cleans and records; it does not build big things itself. Set the model explicitly on every worker. Routing table and evidence: `.claude/skills/orchestrate/models.md`. Review by risk: anything touching an invariant gets a stronger reviewer than the builder. Autonomous multi-worker runs: skill `orchestrate`; surviving hours or days: skill `long-run`.

## Git

- Branches: `<type>/<kebab-name>`, type in `.core/config.env` (`feature bugfix hotfix docs chore`), cut from an up-to-date base (`CORE_BASE_BRANCH`), PR into it, squash merge when the gate is green. Template layers use `layer/N-name`.
- Commit at each green step with a short imperative subject; trailer names the agent and model.
- An API change and its client change ship in the same PR.

## Keeping docs light (one fact, one file, link to it)

- STATUS: hard cap 40 lines / 3 KB, at most 3 open questions. PROGRESS: one line per stage.
- When a slice merges, compact its brief to ~15 lines (goal, finish-line command, PR, outcome) and delete its notes. Durable knowledge goes in a skill or ADR, never STATUS or a brief.
- A skill file over 6 KB moves examples to a sub-file. Never read generated files or archives unless the task needs them.
- Communicate short and plain, answer first; say what was not run.

<!-- stack:begin -->
## Stack

Layer 0 has no stack. When `stack/profile.env` exists (layer 1+), commands and conventions come from it and from the rendered skills (`backend`, `frontend`, `database`, `testing`). Check with `scripts/core/doctor.sh`.
<!-- stack:end -->

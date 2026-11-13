# noble-core

A generic, stack-free **operating system for long-running AI engineering work**: how agents plan, build, test, review, merge, clean up and remember, so a run can go for days with nobody watching and still be traceable afterwards.

It distils what worked (and what broke) in two real projects: a multi-tenant gym platform built almost entirely by an orchestrator driving Claude and Cursor workers, and a cross-platform desktop app built and released across three operating systems.

> Works with Claude Code and Cursor (and any agent that reads `AGENTS.md`). Nothing here depends on a language or framework until you pick a layer that says so.

## The idea in one picture

```text
 goal ──► plan ──► slices ──► workers (one worktree each) ──► gate ──► review ──► merge ──► cleanup
            ▲                                                                              │
            └──────────── ledger · STATUS · ADRs · briefs  (the repo is the memory) ◄──────┘
```

- **The repo is the memory.** A cold start reads `docs/STATUS.md` and the top of `.autonomous/ledger.md` and knows what to do next.
- **An orchestrator plans, routes, gates, merges, cleans and records.** Workers build one slice each, in isolated worktrees.
- **Evidence over claims.** Workers' reports are claims; the orchestrator reads the diff and runs the gate.
- **Decisions are marked.** ADRs with rejected alternatives; decisions made while you were away stay `Proposed`.

## Layers (branches)

Start generic, specialise step by step. Each layer is a branch cut from the one before.

| Branch | Adds | Use when |
|---|---|---|
| `main`, `layer/0-foundation` | process only: rules, orchestration, long-run, checkpoint, slices, ADRs, plans, monitoring, handoff, delivery, scripts, hooks | you have not chosen a stack, or want to pick your own |
| `layer/1-stack-aware` | a stack profile (`stack/profile.env`) and `apply_stack.py` that renders the backend / frontend / database / testing skills for your stack, plus db and gate wrappers | you know your stack and want skills and commands to match |
| `layer/2-stack-presets` | ready presets and fragments (.NET + Flutter + PostgreSQL, Node/TypeScript + React + PostgreSQL, Python/FastAPI + React + PostgreSQL) | your stack is one of them, or you want a worked example to copy |

Your own project adds a final layer: invariants (`docs/INVARIANTS.md`), domain skills, real plan. Details and the upward-merge procedure: [docs/LAYERS.md](docs/LAYERS.md).

## What is in layer 0

| Area | Where |
|---|---|
| Rules for every agent | [AGENTS.md](AGENTS.md) (`CLAUDE.md` and `.cursor/rules/core.mdc` point to it) |
| Workers | `.claude/agents/`: `scout` (cheap lookups), `builder`, `reviewer`, `planner` |
| Skills | `.claude/skills/`: `orchestrate`, `long-run`, `checkpoint`, `slice`, `plan`, `monitor`, `record-decision`, `handoff`, `delivery`, `backend`, `frontend`, `database`, `testing`, `claude-cli`, `cursor-cli` |
| State templates | `docs/templates/`: STATUS, PROGRESS, brief, ADR, ledger, open questions, development / architecture / delivery plans, invariants |
| Scripts | `scripts/core/`: `doctor`, `progress`, `worktree-new`, `worktree-done`, `ledger`, `snapshot`, `queue-runner`; `scripts/hooks/` branch guard |
| Config | `.core/config.env` (branches, caps, merge mode, paths) |

## Quick start

```bash
# use this repo as a template for a new project (or copy these files into an existing one)
sh scripts/core/doctor.sh                     # check the machine and the repo
cp docs/templates/STATUS.md docs/STATUS.md    # then fill it in
cp docs/templates/INVARIANTS.md docs/INVARIANTS.md
```

Then ask your agent: *"Use the `plan` skill to write the development plan for `<goal>`"*, and later *"Use `orchestrate` and `long-run` to work through the plan unattended."* Full walkthrough: [docs/ADOPTING.md](docs/ADOPTING.md). How the pieces fit: [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md). Hard-won lessons: [docs/LESSONS.md](docs/LESSONS.md).

## Safety defaults

Protected branches change only through PRs (a hook enforces it). No secrets in files or command lines. Agents touch only local data. Unattended runs never push to protected branches, force-push, delete unmerged work or enable behaviour-changing switches. Edit `AGENTS.md` and `.core/config.env` to fit your risk appetite, not to remove the guard rails.

## License

MIT

# Adopting the core in a project

## New project

1. Create the repo from this template (or copy: `AGENTS.md`, `CLAUDE.md`, `.claude/`, `.cursor/`, `.core/`, `scripts/`, `docs/templates/`).
2. Edit `.core/config.env`: protected branches (add `dev`/`qc` if you use them), base branch, merge mode.
3. Register the hook in `.claude/settings.json` (already there) and make sure `scripts/hooks/*.sh` are executable.
4. `sh scripts/core/doctor.sh`.
5. Copy templates: `docs/templates/STATUS.md` -> `docs/STATUS.md`, `INVARIANTS.md` -> `docs/INVARIANTS.md`, plan templates -> `docs/plan/`.
6. Plan: ask the agent to use skill `plan`. Record the stack as ADR 0002. Fill `docs/INVARIANTS.md` with what must never break and how each is enforced.
7. First slice: `/slice new "walking skeleton"`. Prove the gate end to end before scaling out.
8. Unattended: write the run contract (`docs/templates/ledger.md` -> `.autonomous/ledger.md`), then ask for `orchestrate` + `long-run`.

## Existing project

Do steps 1-5 on a branch. Move today's rules into `AGENTS.md` (shorter is better) and invariants into `docs/INVARIANTS.md`. Keep existing skills; add the ones you lack. Leave history alone.

## Tuning

- **Model routing:** edit `orchestrate/models.md` with your evidence; date each change.
- **Autonomy:** the "Act freely / Ask first" lists in `AGENTS.md` and the run contract's standing authority.
- **Caps:** `.core/config.env`.
- **Cursor as orchestrator:** same files; the Cursor rule points at `AGENTS.md`; Claude work goes through `claude -p`.

## Daily rhythm

Start: `/checkpoint resume`. Work: slices. Long absence: run contract + `orchestrate`. End: `/checkpoint save`. Anything surprising: add a line to `docs/LESSONS.md` or the owning skill.

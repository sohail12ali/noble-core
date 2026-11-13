---
name: checkpoint
description: Resume or save project state between sessions using docs/STATUS.md, docs/PROGRESS.md and the active slice brief, so a new session needs only a few small files. Use at the start of work after a break ("where were we", "resume") and at the end of every session that changed something ("wrap up", "save progress", "checkpoint").
---

# /checkpoint

```text
/checkpoint resume     # read the minimum to continue
/checkpoint save       # write what changed and what is next
```

## resume

1. Read `docs/STATUS.md`. If it names an active slice, read that `brief.md` only. Never read archives.
2. `git status -sb`, `git log --oneline -5`: confirm branch and last work match STATUS; if not, say so.
3. Long runs: first block of `.autonomous/ledger.md` (contract + Next action).
4. Progress: only the Overall line and stage table. Decisions: last 10 rows of the ADR index.
5. Reply in at most 5 lines: stage, slice, last done, next step, questions waiting on the owner.

## save

1. Update `docs/STATUS.md` from `docs/templates/STATUS.md`. Hard cap 40 lines / 3 KB, at most 3 open questions (more go to `docs/open-questions.md`, each with a recommendation). Never paste code, logs or diffs.
2. Update `docs/PROGRESS.md`: date, Overall line, the stage row (and active/todo slice rows). `done` only with finish-line evidence.
3. Active slice: tick finished tasks in the brief. Durable knowledge goes in the owning skill or an ADR.
4. Decision made and not recorded: `/record-decision`.
5. Plan changed: update `docs/plan/`.
6. Long run: refresh the ledger's **Next action**.
7. Run `sh scripts/core/doctor.sh` (caps). Report files updated, one line each. Do not commit unless asked or the run contract allows it.

## Rules

STATUS is a pointer board, not a diary. One fact, one file; link instead of copying. Never record secrets, tokens or personal data in any doc.

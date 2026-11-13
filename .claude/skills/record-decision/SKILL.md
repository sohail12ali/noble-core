---
name: record-decision
description: Record a decision as a short ADR in docs/decisions/, update the index, and sync plan and rules when it is a rule. Use whenever the owner decides something in chat, a plan question is decided, a dependency is added, or a slice makes a design choice others must follow.
---

# /record-decision

```text
/record-decision "{title}"
```

1. **Check first.** Search `docs/decisions/README.md`. If an ADR exists and this changes it, write a new one that **supersedes** it and mark the old `Superseded by NNNN`. Never rewrite history.
2. **Write** `docs/decisions/NNNN-kebab-title.md` from `docs/templates/ADR.md`. Next number = highest + 1, four digits. Under ~40 lines: context, decision, rejected (with why), consequences.
3. **Quote the source.** Owner's decision: their words, short. Decided inside a slice or while they are away: say so; status `Proposed` until they agree.
4. **Index:** one row in `docs/decisions/README.md`.
5. **Sync only where needed:** a rule every agent must follow gets one line in `AGENTS.md` (or `docs/INVARIANTS.md`) pointing at the ADR; a how-to change updates the owning skill; the plan file if a question was decided.
6. Report the ADR path and what was synced.

One decision per ADR; small ones count (a library, a naming rule). Never decide a product, money or safety rule on the owner's behalf: write it `Proposed` and ask.

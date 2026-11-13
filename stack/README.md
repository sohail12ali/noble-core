# Stack

`profile.env` says which stack this project uses and how to run it. `apply_stack.py` turns it into skills and docs the agents read.

```bash
cp stack/profile.example.env stack/profile.env     # or a preset (layer 2): python3 scripts/core/apply_stack.py --profile stack/presets/<name>.env
$EDITOR stack/profile.env
python3 scripts/core/apply_stack.py                # fills the stack sections of backend / frontend / database / testing skills and AGENTS.md
python3 scripts/core/apply_stack.py --check        # CI/doctor: fails when stale
```

| Piece | What it does |
|---|---|
| `profile.env` | stack selection, pinned versions, commands (build, lint, test, run, database, gates) |
| `fragments/<kind>/<name>.md` | the stack's conventions and pitfalls for that slot; `_template.md` to add one |
| `scripts/core/gate.sh focused\|changed\|all` | runs the profile's gate commands; a gate that runs nothing fails |
| `scripts/core/db.sh ...` | guarded database wrapper; refuses unless `DB_TARGET` is `local` or `dev`, or a `DATABASE_URL` looks like production |
| `docs/stack-versions.md` | generated from the `VERSION_*` keys |

All values `none` reproduces layer 0. Changing stack later: change the profile, re-render, record an ADR (`record-decision`), and update the invariants' enforcement lines.

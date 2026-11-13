# Layers

The template is a stack of branches. Lower layers know less (nothing about your stack); higher layers know more.

```text
layer/0-foundation   process only; also `main`
   └─ layer/1-stack-aware     stack profile + renderer + wrappers
        └─ layer/2-stack-presets    ready presets and fragments
             └─ (your project)      invariants, domain skills, real plan, real stack profile
```

## What belongs where

| Layer | Allowed | Not allowed |
|---|---|---|
| 0 foundation | rules, orchestration, long-run, checkpoint, slices, ADRs, plans, monitoring, handoff, delivery, git hooks, scripts that work on any repo | language, framework, database engine or product names as requirements (examples marked as examples are fine) |
| 1 stack-aware | a profile schema, `apply_stack.py`, fragment slots, command wrappers (`db.sh`, `gate.sh`) driven by the profile; an empty/`none` profile that reproduces layer 0 | specific stacks' content beyond a tiny test fixture |
| 2 presets | per-stack fragments (commands, conventions, pitfalls) and presets that select them | project-specific rules |
| project | invariants, domain skills, plan, ADRs, real profile | anything that would help other projects (send it back down) |

## Using a layer

- **Start generic:** clone/copy `main`. Pick your stack later.
- **Start with a preset:** clone `layer/2-stack-presets`, copy a preset to `stack/profile.env`, run `python3 scripts/core/apply_stack.py`, commit.
- **Add a stack not covered:** copy `stack/fragments/<kind>/_template.md`, write the fragment, add it to your profile, render.

## Improving the template (upward merge)

A fix to process belongs in layer 0, then flows up:

```bash
git switch layer/0-foundation   # work on a work branch cut from here, PR back into it
# ...after it merges:
git switch layer/1-stack-aware && git merge layer/0-foundation
git switch layer/2-stack-presets && git merge layer/1-stack-aware
```

`main` follows `layer/0-foundation`. Conflicts are almost always the rendered skills (`backend`, `frontend`, `database`, `testing`): take layer 0's text change into the layer 1 *template*, then re-render.

Rule of thumb: if a lesson would still be true on a different stack, it goes in layer 0.

## Adding a layer between

A new layer (for example `layer/1b-multi-tenant-saas` adding tenancy invariants and isolation tests) is cut from the layer it refines and documented here with its row in the table above.

# 0001. Layered template, three starting layers

- **Status:** Accepted
- **Date:** 2026-11-13
- **Source:** Owner brief: start generic with nothing defined, then specialise toward a tech stack in steps.

## Context

Long autonomous runs (Noble Gym, Multi Control) taught us the same process lessons on every stack. Stack-specific content (commands, conventions, schema rules) was mixed into process content, so none of it could be reused.

## Decision

Maintain the template as stacked branches. `layer/0-foundation` (also `main`) is stack-free process. `layer/1-stack-aware` adds a stack profile and a renderer that specialises the skills. `layer/2-stack-presets` adds ready presets and fragments. Each layer is cut from the previous one; improvements to a lower layer are merged upward. Projects start from the highest layer that fits and add a project layer of their own (invariants, domain skills).

## Rejected

- Single repo with every stack side by side: noise for every user, no clear "nothing defined" start.
- Copy-paste per project: lessons never flow back.
- Git submodule or package for skills: agents read files in the repo; indirection costs more than it saves.

## Consequences

Upward merges are a chore (`docs/LAYERS.md` has the procedure). Layer 0 must stay free of stack words; `scripts/core/doctor.sh` and review enforce it.

---
name: frontend
description: Write and review client code - web, mobile or desktop UI, state, API clients, accessibility, localization. Layer 0 gives stack-free principles; once a stack profile exists this skill is re-rendered with the stack's commands and conventions. Use for any task in the client code.
---

# frontend

Stack: not defined (layer 0). Layer 1 adds `scripts/core/apply_stack.py`, which re-renders this file from a stack profile.

## Principles

- **Never trust the client for security or money.** The client displays and requests; the server decides. A success callback on the client never activates anything.
- **Layers.** Screens -> state -> repositories/API client -> transport. Fake the API at the repository boundary in tests; hand-written fakes with fixed data beat mocking frameworks.
- **State.** One predictable state mechanism per app; side effects in one place; loading, empty, error and offline states are designed, not accidental.
- **Accessibility is not optional:** semantic labels, contrast, focus order, text scaling, touch target size; tests find elements by semantics or keys, never by translated text.
- **Localization from day one:** no literal user-facing strings in widgets/components; check every language file for parity; plan right-to-left if any target language needs it.
- **Responsive:** design at the smallest supported width first; layouts reflow, nothing scrolls sideways by accident.
- **Performance:** no work while hidden or idle; refresh on demand, not by polling everything; measure before and after tuning.
- **Design tokens** (colour, type, spacing) in one place; themes swap tokens, not components.
- Dev-only sign-in or tooling is behind a build flag that is off in release builds.

## Commands

Defined by the stack profile: `BUILD_CMD`, `TEST_CMD`, `LINT_CMD`, `RUN_CMD` (see `stack/profile.env`).

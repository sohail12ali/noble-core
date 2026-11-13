**Runtime and layout:** Flutter/Dart pinned in the baseline; a Dart workspace: `app/packages/<core, features>` shared code and `app/apps/<member, admin, ...>` per-audience apps. One app can carry several role shells.

**Conventions:**

- Riverpod for state; repositories wrap the API client; hand-written fakes with fixed data at the repository boundary (no mocking framework).
- Money is Dart `int` minor units plus currency, formatted by one helper.
- All user-facing strings in ARB files; a parity test fails when any language is missing a key; right-to-left layouts tested if a target language needs it. Generated l10n files are never read or hand-edited.
- Widget tests find by semantics or keys, never by translated text. Dev login is behind `--dart-define=DEV_LOGIN=true`, off in release builds.
- `flutter analyze` once for the whole workspace; `flutter test` in each package, one process at a time (the largest app is slow).

**Pitfalls:**

- Generated l10n and shared registries (routers, fakes, ARB) conflict across parallel slices: merge such slices sequentially, keep both sides, regenerate.
- Web builds need CORS and a base URL for the dev API; a release web build can be served locally for checks.
- Long sweeps (accessibility, responsive) over many screens exceed headless worker limits: run them with a Claude builder or in the gate, in pieces.

**Layers here:** pytest unit tests (parametrized for edge cases), integration tests against a real PostgreSQL with a throwaway database per run/worker, `ruff` + `mypy` as the analyzer gate, Playwright for a few end-to-end flows.

**Gates:**

- Building: `pytest <path> -x -q`, `ruff check <paths>`, `mypy <package>`.
- Merge gate: `pytest --picked` style selection (or a script mapping the diff to test paths) plus ruff and mypy.
- All: ruff, mypy, full `pytest` (with `-n auto` only if each worker gets its own database).
- Needs a database URL env var; a skip is not a pass.

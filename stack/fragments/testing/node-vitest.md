**Layers here:** Vitest (or Jest) for unit tests next to the domain, integration tests against a real PostgreSQL with a throwaway schema/database per worker, `tsc --noEmit` + ESLint as the analyzer gate, Testing Library for components, Playwright for a few end-to-end flows.

**Gates:**

- Building: `npx vitest run <path>` for the files touched, `npx tsc --noEmit`, `npx eslint <paths>`.
- Merge gate: `vitest related` (or `--changed`) plus type-check and lint; integration tests only for affected modules.
- All: type-check, lint, full unit + integration, then Playwright.
- Needs a database URL env var for integration tests; without it they must fail loudly or skip with a reason, and a skip is not a pass.

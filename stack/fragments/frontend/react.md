**Runtime and layout:** React with TypeScript `strict`, Vite. `src/{app,features/<name>,shared}`; server state in TanStack Query, local UI state in components, routing with React Router. Commit the lockfile; `npm ci`.

**Conventions:**

- An API client module wraps `fetch` with typed responses validated by a schema; features never call `fetch` directly.
- Money is integer minor units plus currency, formatted with `Intl.NumberFormat` in one helper.
- Strings go through an i18n library; a test fails when a locale misses a key. Layouts use logical CSS properties so right-to-left works.
- Accessibility: semantic elements first, `eslint-plugin-jsx-a11y`, Testing Library queries by role/label; end-to-end flows with Playwright.
- Fake the API in component tests with a request-mocking layer or hand-written fakes at the client boundary.
- Dev-only sign-in only under `import.meta.env.DEV`.

**Pitfalls:**

- Effects that poll keep idle cost high: fetch on demand, refetch on focus, pause when hidden.
- Duplicated server state in local state drifts: let the query cache own it.
- Bundle creep: check the build report before adding a dependency (needs an ADR anyway).

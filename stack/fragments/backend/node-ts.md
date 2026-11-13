**Runtime and layout:** Node.js LTS (pin in `.nvmrc` / `engines`), TypeScript with `strict`, ESM. `src/modules/<name>/{domain,app,infra}`, `src/http`, `tests/{unit,integration}`. Commit the lockfile; install with `npm ci`.

**Conventions:**

- Validate every request body, query and env var at the edge with a schema library (zod or similar); infer types from the schema.
- Domain code is pure functions and types. Money is an integer of minor units (`bigint` or safe integer) plus currency; never floating point. A lint rule or test bans arithmetic on `number` money.
- Ports are interfaces; adapters are injected (constructor or a small container); fakes for dev and tests. Dev-only routes are registered only when `NODE_ENV=development`, with a test.
- A clock is injected; no `Date.now()` in domain code.
- `tsc --noEmit` and the linter are the analyzer gate.

**Pitfalls:**

- ESM/CJS mixing breaks tooling silently: pick ESM and keep test runner config consistent.
- Unhandled promise rejections hide data loss: handle or let the process fail loudly.
- Test workers sharing one database collide: give each worker its own schema or database.
- Never log request bodies or tokens.

**Look-ups:** the framework's and library's current docs (versions move fast); check the lockfile for what is installed.

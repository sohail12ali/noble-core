**Runtime and layout:** .NET (pin the SDK in `global.json`); `backend/src/<App>.Api` (host), one project per module or vertical slice, `backend/tests/{UnitTests,IntegrationTests,ArchitectureTests}`, a small `DbMigrate` tool. Modular monolith: modules talk through contracts, never through each other's internals.

**Conventions:**

- Minimal APIs or controllers with endpoint filters for authorization; policies per role; deny by default.
- Domain types are pure (no EF, no I/O). Money is a `Money` record over `long` minor units plus an ISO currency; `double`, `float` and `decimal` are banned by an architecture test.
- EF Core is for queries and the tenant filter; the schema comes from plain SQL migrations, never from EF migrations. A model-versus-schema test keeps them aligned.
- Outside services only through ports with a dev fake, registered in DI; dev-only endpoints (`/dev/*`) exist only when the environment is Development and a test proves they 404 elsewhere.
- Time through an injected `IClock`; never `DateTime.Now`.
- Latest stable packages only from the baseline; look up APIs in the official docs, not memory.

**Pitfalls (learned the hard way):**

- xUnit v3 on Microsoft.Testing.Platform: `dotnet test` needs `--solution <file>` or `--project <file>`.
- Several `--filter-namespace` flags OR together; mixing class and namespace filters ANDs to zero tests.
- Clearing the NuGet cache breaks test-runner resolution: `dotnet restore <solution>` and rebuild.
- On macOS a hot forked child can stall a test host (many tests time out at the same instant): rerun those alone; do not `pkill` test hosts.
- Parallel suites on one PostgreSQL time out or fail with `Cannot drop`: run one at a time.

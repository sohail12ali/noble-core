**Layers here:** xUnit v3 unit tests (table-driven `[Theory]`), integration tests on `WebApplicationFactory` with a real PostgreSQL and the migration runner (unique throwaway database per test), architecture tests (dependency direction, banned money types), Flutter unit and widget tests per package, a few `integration_test` flows.

**Gates:**

- Building: `dotnet test --project <one test project> --filter-method "*Name*"`; `flutter analyze` and `flutter test` in the package touched.
- Merge gate: a script that maps the diff to unit + architecture + only the integration namespaces affected (mixing filter kinds ANDs to zero). Needs the test connection string for a CREATEDB role in an env var; without it database tests skip, and a skip is not a pass.
- All: build + test the solution, analyze + test every Dart package, one process at a time.

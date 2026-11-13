**Runtime and layout:** Python 3.12+ in a virtualenv managed by `uv` or `pip-tools` (pinned lockfile). `app/modules/<name>/{domain,services,adapters}`, `app/api`, `tests/{unit,integration}`.

**Conventions:**

- Pydantic models validate every input at the edge; FastAPI dependencies carry auth and the tenant context; deny by default.
- Domain code is plain Python with no framework imports. Money is an `int` of minor units plus currency code; no `float`, and `Decimal` only at parsing/formatting edges.
- Ports as `Protocol`s, adapters injected via dependencies, fakes for dev and tests. Dev-only routes only when `ENV=development`, with a test.
- Time is timezone-aware UTC and comes from an injected clock; never naive datetimes.
- Gate: `ruff check`, `ruff format --check`, `mypy` (strict on domain), then tests.

**Pitfalls:**

- Blocking calls inside `async def` handlers stall the event loop: use the sync handler form or a thread pool.
- `pytest-asyncio` loop scope mismatches cause cross-test leaks: set it explicitly.
- A shared test database across xdist workers collides: one database or schema per worker.
- Never log secrets or personal data; scrub exception messages.

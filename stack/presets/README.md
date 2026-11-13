# Presets

Starting points, not truth: paths (`backend/App.slnx`, `web/`, `api/`) and tool versions are examples. Copy one, edit it to your layout, render.

| Preset | Backend | Frontend | Database | Testing |
|---|---|---|---|---|
| `dotnet-flutter-postgres` | .NET | Flutter | PostgreSQL | xUnit + flutter test |
| `node-react-postgres` | Node + TypeScript | React (Vite) | PostgreSQL | Vitest + Playwright |
| `python-fastapi-postgres` | Python + FastAPI | React (Vite) | PostgreSQL | pytest + Vitest |

```bash
python3 scripts/core/apply_stack.py --profile stack/presets/node-react-postgres.env
```

Commands that reference scripts which do not exist yet (for example `scripts/test-changed.py`) are placeholders: write them in the first slice (a "tests for what changed" mapper is the highest-value one). Add a stack by writing fragments (`stack/fragments/<kind>/_template.md`) and a preset that selects them; document it in `docs/LAYERS.md` if it is generally useful.

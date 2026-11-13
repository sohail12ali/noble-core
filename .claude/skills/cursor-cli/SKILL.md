---
name: cursor-cli
description: Drive the Cursor Agent CLI (`agent`, same binary as `cursor-agent`) as a headless worker from another agent or script - headless -p runs, JSON output, modes, models, sandbox. Use when an orchestrator (Claude or other) must hand a task to Cursor or run several Cursor workers, or when Cursor is the orchestrator and needs its own conventions. Cursor CLI only.
---

# cursor-cli: operate Cursor Agent from an agent

Flags change between versions: trust `agent --help` over this file. A bad model id fails with exit 1, nothing on stdout, and stderr lists every valid id.

```bash
agent -p "<self-contained task>" \
  --model <model-id> \
  --trust --sandbox enabled --force \
  --output-format json < /dev/null
```

Long prompt: `agent -p --model <id> --trust --output-format json < task.md`.

1. **`-p` is mandatory.** `--trust` skips the workspace prompt: trusted directories only.
2. **The prompt must stand alone** (goal, files, finish line, "do not push"). Plan and ask modes cannot question you in `-p`.
3. **Writes need `--force`**, keep `--sandbox enabled`. Do not combine `--force` with `--mode ask|plan`.
4. **No budget or turn flag:** wrap long runs in a timeout. Keep each task under ~30 minutes; long turns running big suites lose the connection: run suites in your gate, outside the turn.
5. **Close stdin** (`< /dev/null`) when the prompt is an argument.
6. **Preflight auth** (`agent status --format json`); the output contains account details: do not paste it into logs. Prefer an env API key over `--api-key`.
7. **Never use pickers** (`--resume` with no id, `agent ls`, attach).
8. On failure the JSON is absent; read stderr and the exit code.
9. When Cursor orchestrates: use its own subagents/worktrees for Cursor work, and `claude -p` for Claude work (skill `claude-cli`), same worker briefs and gates.

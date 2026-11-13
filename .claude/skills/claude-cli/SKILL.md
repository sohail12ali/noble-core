---
name: claude-cli
description: Drive the Claude Code CLI (`claude`) as a headless worker from another agent or script - headless -p runs, JSON output, permission modes, tool allowlists, budgets, model aliases. Use when an orchestrator (Cursor or other) must hand a task to Claude Code or run several Claude workers. Claude CLI only.
---

# claude-cli: operate Claude Code from an agent

Flags change between versions: if `claude --version` differs from what you know, trust `claude --help`. Never guess a flag.

```bash
claude -p "<self-contained task>" \
  --model sonnet \
  --permission-mode acceptEdits \
  --allowedTools "Read,Grep,Glob,Edit,Bash(git diff *)" \
  --max-budget-usd 2 \
  --output-format json < /dev/null
```

Long prompt: `claude -p --model sonnet --output-format json < task.md`.

1. **`-p` is mandatory** or the interactive UI opens and hangs. `-p` skips the trust dialog: run only in directories you trust.
2. **The prompt must stand alone:** goal, files, constraints, finish-line command, commit trailer, "do not push". Use `orchestrate/worker-brief.md`.
3. **Always set limits:** explicit `--model`, `--max-budget-usd`, narrowest `--allowedTools`. No turn or wall-clock flag: wrap long runs (`perl -e 'alarm shift; exec @ARGV' 900 ...` on macOS, `timeout` elsewhere).
4. **Never `--dangerously-skip-permissions`** outside a sandbox with no internet. In `-p`, anything not allowed is denied, not asked.
5. **Close stdin** (`< /dev/null`) when the prompt is an argument.
6. **Preflight auth** on long runs (`claude auth status`); never put keys in prompts or logs.
7. **Never use pickers** (`--resume` with no id, attach, interactive listings).
8. **Judge by `is_error` and exit code**, not by the `subtype` field. A bad model name can still say `subtype: success`.
9. The report is a claim: check the diff and run the gate yourself.

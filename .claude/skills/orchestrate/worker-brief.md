# Worker brief (copy, fill, hand to one worker)

```text
You are a worker on {repo}. Work only in {worktree path} on branch {type/name}.

Goal: {one sentence}
Read first: AGENTS.md, {brief path}, skill(s): {names}. Read nothing else unless needed.
Do: {tasks in order, each traced to a check}
Do not: push, touch protected branches, run suites of other slices, add dependencies outside the baseline, touch files outside: {list}.
Finish line (must pass): {command}
Commit at each green step. Message: "{subject}". Trailer: "Co-Authored-By: {agent and model} <noreply@...>".
If you hit your output limit, resume in small steps, one file per tool call; never restart from scratch.
Report (short): files changed, commands run with results, what you did not run, questions needing a decision.
```

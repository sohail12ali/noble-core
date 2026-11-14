# noble-core

Give an AI agent one plan, go to sleep, and wake up to a branch, a measured report and a short list of questions.

This is a small starting kit for long, unattended engineering runs with Claude Code (Cursor reads the same `CLAUDE.md`). It deliberately does not tell the agent *how* to work. Current models plan and build well on their own. It supplies the few things they cannot supply for themselves.

| The agent cannot know or do this alone | So the kit provides |
|---|---|
| What you want, what must never break, what it may do without you | [`PLAN.md`](PLAN.md): one file you own |
| Remember anything after its context resets | `run/STATE.md`, `run/JOURNAL.md`: the repo is the memory |
| Ask you a question at 3 a.m. | `run/INBOX.md`: it takes its recommended default, writes it down, keeps going |
| Keep itself running all night | [`run/loop.sh`](run/loop.sh): fresh session after fresh session until done, blocked or a limit |
| Be trusted on "it works" | `scripts/verify.sh`: the loop runs the gate itself and writes `run/REPORT.md` from measurements |
| Stay inside the lines | `scripts/guard.sh` hook and a deny list: no protected branches, no force-push, no merging, no editing the plan or the gate |

## Use it

```bash
# 1. Copy this repo's files into your project (or start a project from it).
# 2. Ask the agent: "use the plan skill". It interviews you once and writes PLAN.md and the gate.
# 3. Start the run and leave:
nohup bash run/loop.sh > /dev/null 2>&1 &
# 4. Any time:
sh scripts/status.sh        # where it is
touch run/STOP              # stop after the current session
# 5. In the morning: read run/REPORT.md, answer run/INBOX.md, review the branch, merge it yourself.
```

Limits (sessions, hours, budget per session, stall detection) and the engine are in [`core.env`](core.env).

## How a run behaves

```text
PLAN.md ──► loop ──► fresh session ──► work, commit, update STATE / JOURNAL / INBOX ──┐
              ▲                                                                       │
              └── loop measures: new commits? gate green? status? ◄───────────────────┘
                  stops on: done + gate not red · blocked · stuck · time · sessions · run/STOP
```

- Every session starts cold and reads the files, so losing context costs nothing.
- Work left uncommitted at the end of a session is committed by the loop, so nothing is lost.
- "Done" with a red gate is not accepted; the loop continues.
- No new commits several sessions in a row means stuck: the loop stops instead of burning money.
- The agent never merges. It delivers a run branch (optionally pushed, optionally a draft pull request).

## What is in the box

`CLAUDE.md` (the rules, one file) · `PLAN.md` · `core.env` · `run/` (loop, prompt, state, journal, inbox, unattended permissions) · `scripts/` (verify, guard, lock, status) · two skills (`plan`, `run`) · three agents, one per level (`scout` Haiku, `worker` Sonnet, `reviewer` Fable; the lead session runs on Opus) · `docs/DECISIONS.md` · `docs/LESSONS.md` (earned in real overnight runs).

## Models and parallel work

`CLAUDE.md` assigns work by level: look-ups to Haiku, building to a check to Sonnet, building with judgement to Opus, deciding and reviewing to Fable. The lead session fans independent tasks out to workers, each in its own git worktree (at most `MAX_PARALLEL`), and integrates their branches one at a time through the gate. `scripts/lock.sh` gives every worktree one shared lock for things they would collide on, such as a test database; the gate itself takes it. The report lists any worktree left in flight.

## Safety, plainly

An unattended agent needs broad command access because nobody is there to approve prompts. The hook and deny list hold the hard limits, but they are a seat belt, not a cage. Run it on a machine or container where the worst case is acceptable, with test keys only, and review the branch before merging.

## The earlier, heavier version

Branches `layer/0-foundation`, `layer/1-stack-aware` and `layer/2-stack-presets` hold the first design: a full prescribed method with fifteen skills and stack presets. Why it was replaced: [docs/DECISIONS.md](docs/DECISIONS.md).

## License

MIT

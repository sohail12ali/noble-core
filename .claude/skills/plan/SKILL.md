---
name: plan
description: Turn the owner's idea into a PLAN.md an agent can execute alone for hours or days, by interviewing the owner once, up front. Use when starting a project or a big task, when the owner says "plan this", "I want to build", "set up an overnight run", or when PLAN.md is still the template.
---

# plan: the one conversation that replaces a night of questions

This is the only stage that needs the owner. Everything you fail to ask now becomes a guess at 3 a.m. Your job is to leave with a `PLAN.md` that a session with no memory and nobody to ask can finish.

## How

1. **Listen first.** The brief is often dictated and loose. Restate it in a few lines and get a yes before going deeper.
2. **Look before asking.** Read the repo, existing docs and decisions. Never ask what a file can tell you.
3. **Ask only what would block or misdirect the run**, a few questions at a time, each with your recommended answer so "yes" is enough:
   - What does finished look like to a user? What is the smallest version that counts?
   - What must never break, even to reach the goal?
   - What is out of scope that an eager agent would build anyway?
   - What may the agent do alone (push the branch, open a draft pull request, add dependencies), and what waits?
   - What needs a human hand before the run: accounts, test keys, a local database, sign-ins, installed tools? Get these done now; an agent cannot.
4. **Make "Done means" provable.** Each line names a command or scripted demo. If a line cannot be checked by a machine, either turn it into one that can or move it to a checklist for the owner and say so.
5. **Set the gate.** Agree on `VERIFY_CMD` in `core.env`: one command, exits 0 when the project is healthy. If nothing exists yet, the plan's first "Done means" line is building it. Run it once now.
6. **Write `PLAN.md`** (keep the section names), delete the `TEMPLATE:` line, reset `run/STATE.md` if it holds an old run, and show the owner the plan. They own it from here.
7. **Rehearse.** Read the plan as a stranger would. Whatever you would have to ask, ask now.

## Do not

Do not break the work into tasks or steps in the plan: the running agent does that itself and does it better with the code in front of it. Do not pad: a plan is good when nothing can be removed without causing a wrong turn.

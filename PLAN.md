TEMPLATE: delete this line when the plan is real. The loop refuses to start while it is here.

# Plan: {name}

Owned by the owner. Agents read it and never edit it. Write it once, well: every answer missing here is a question at 3 a.m. with nobody to ask. The `plan` skill interviews you and fills it in.

## Goal

{What exists when this is finished, in the user's terms. A paragraph is enough.}

## Done means

Each line is something a command or a scripted demo can prove. The agent decides the steps; these decide when it stops.

- [ ] {observable outcome} — proven by `{command}`
- [ ] `sh scripts/verify.sh` is green

## Never break

Rules that outrank the goal (money, privacy, data separation, safety). Each one should have a test; if it does not, the first task is to write it.

- {rule}

## Out of scope

- {what not to build, even if it looks helpful}

## May do alone

- Everything on the run branch: code, tests, local database, dependencies that are free and recorded.
- {e.g. push the run branch and open a draft pull request}

## Must wait for me

- Merging into a protected branch. Anything production, paid, public or involving secrets.
- {anything else}

## Context

{Stack, where things live, how to run locally, accounts or test keys already set up, earlier decisions that still hold. Link, do not paste.}

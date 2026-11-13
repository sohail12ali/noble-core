# Delivery plan: {project}

_Updated: YYYY-MM-DD_

## Environments

| Env | Purpose | Data | Deploy trigger | Who approves |
|---|---|---|---|---|
| local | development | seed/fake | manual | agent |

## Pipeline

Build -> test (focused gate / full suite) -> package -> publish -> verify. Which steps are automated, which run on whose machine, which need a human.

## Versioning and release

{Scheme, changelog, tags, where artifacts go, one command per step.}

## Rollout and rollback

{Staged exposure, feature switches, how to roll back code and data (forward-only migrations: expand then contract).}

## Verification

{Smoke test after deploy; checks only real hardware or a real user can do (checklist file).}

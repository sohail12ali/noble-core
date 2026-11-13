# Architecture plan: {project}

_Updated: YYYY-MM-DD_

## Context and constraints

{Users, scale, team, budget, compliance, deadlines.}

## Shape

{Monolith / modular monolith / services; modules and their boundaries; one diagram (mermaid) is enough.}

## Stack

See `stack/profile.env` and ADRs. Baseline versions: `docs/stack-versions.md`.

## Data

{Stores, ownership per module, tenancy/isolation model, retention, backup and restore.}

## Interfaces

{APIs, events, ports to outside services and their dev fakes.}

## Cross-cutting

Auth and authorization · secrets · logging and tracing · errors · i18n · accessibility · performance budget (idle and peak) · observability.

## Decisions

| ADR | Title | Status |
|---|---|---|

---
name: handoff
description: Pass work between machines, sessions or assistants without losing state - park a run, snapshot it, resume on another computer, or split one project across computers (build on each OS) with assistants handing tasks to each other. Use when the owner is leaving, moving machines, when a task needs a different OS or hardware, or when several assistants work on one project.
---

# handoff

## Park a run (leaving or moving machines)

1. Finish or commit the current step; merge or park every branch (push parked branches if the owner allowed pushing).
2. `sh scripts/core/ledger.sh "..."` and refresh **Next action**; `/checkpoint save`.
3. Run the cleanup pass in `orchestrate/cleanup.md`: finished worktrees removed, test databases and temp credential files dropped.
4. `sh scripts/core/snapshot.sh` writes a bundle of every branch, a patch of uncommitted work, and copies of ledger, STATUS and plan to `CORE_QUEUE_DIR/snapshots/<timestamp>/` for anything that does not live in git.
5. Say what stays local (databases, secrets, caches) and how to recreate it (stack `database` skill, seed scripts).

## Resume on another machine

Clone or pull, `sh scripts/core/doctor.sh`, restore local data with the seed scripts, `/checkpoint resume`, read the ledger head. The repo is the memory; the chat is not.

## Several computers, several assistants

When one project is built or tested on different OSes or hardware (each OS builds only its own installers; real-device checks need that device):

- One machine coordinates; others run only an allow-listed set of commands for the project folder (exact command prefixes, no shell pipes), never an open shell.
- Hand tasks as messages with a thread name, a kind (`handoff`, `question`, `status`, `result`), the sender's name and machine, and the files to fetch. A `result` closes the thread. Keep the log append-only so you can trace who asked whom for what.
- Messages to a sleeping machine wait; the receiver must be running to read. Start each assistant with "check the channel".
- Receiver decides what to allow. Refusals say why; nothing is resent silently.
- Example implementation of this pattern: the Noble Relay assistant channel and Fleet jobs (`channel_post`/`channel_read`, `run_job`). Any transport works if it keeps these properties.
- Write the playbook per project in `AGENTS.md` or a doc it links: which machine does which step, the exact commands, and what only a human may do (publishing, signing keys).

## Rules

Never copy signing keys, tokens or databases into a public place or a chat. Publishing is a human-confirmed step.

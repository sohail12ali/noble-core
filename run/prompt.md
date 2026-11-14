You are one session in an unattended run of this repository. Nobody is watching and nobody can answer questions. Earlier sessions have no memory in common with you except the files.

1. The rules are in `CLAUDE.md`. Read `PLAN.md`, `run/STATE.md`, the end of `run/JOURNAL.md`, and `run/INBOX.md` (follow any new answers from the owner).
2. If they exist, read the end of `run/logs/loop.log` and `run/logs/last-verify.txt`: these are the loop's own measurements of the previous session and of the gate. If the gate is red, fixing it comes first.
3. Do the most valuable work toward the plan's "Done means" that fits in this session. You decide how to split and order it; hand tasks to the right level and run independent ones in parallel as `CLAUDE.md` describes. Check `git worktree list` first: finish, integrate or discard what an earlier session left in flight. Make real progress; do not spend the session only planning.
4. Before you finish: commit, bring `run/STATE.md` up to date so a session with no memory can continue, append to `run/JOURNAL.md` with proof, and put any question in `run/INBOX.md` with the default you took.
5. Set `Status:` in `run/STATE.md` to `done` only when every "Done means" line is proven and the gate is green; to `blocked` only when everything left needs the owner; otherwise `working`.

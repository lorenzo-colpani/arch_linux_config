---
name: plans
description: Loads the repo's roadmap context for work on this project's plans. Use when the user mentions plans, the roadmap, plans.md, plans.yaml, or the plans/ folders, or before starting any task tied to a plan.
---

# Plan System

The roadmap lives in `plans.md`, `plans/<name>/`, and a per-project SQLite
registry served by the `mind` MCP server (tools prefixed `plans_`).
`plans.md` is the source of truth for the process. The registry is the source
of truth for state. `plans.yaml` is a generated snapshot — never edit it.

If the repo has no `plans.md`, this system does not apply here. Stop and say so.

## Before plan work

1. Read `plans.md`. It defines the lifecycle and the index.
2. Call `plans_show` (no arguments) for the board. Check `status`,
   `progress`, dependencies of the target plan.
3. Read `plans/<name>/README.md`. It holds the branch, steps, and done criteria.
4. Read `plans/<name>/discussion.md`. Required when `status` is `in_progress`
   or the README lists open points.

Respect `depends_on`. A plan starts only when its dependencies are `done`.
Call `plans_ready` to see what is unblocked right now.

## While you work

- Set `status: in_progress` with `plans_update` when you start.
- Write notes and blockers into `progress` with `plans_update`.
- Append decisions to `plans/<name>/discussion.md`.
- Mutating tools sync `plans.md` and regenerate `plans.yaml` automatically.
  Never edit those two files by hand.

## On completion

1. Run the review gate: the `code-review` skill.
2. Set `status: done` plus the squash-merge commit with `plans_update`.
3. Delete the plan folder.

Do not copy these rules elsewhere. `plans.md` owns them.
---
name: plans
description: Loads the repo's roadmap context for work on this project's plans. Use when the user mentions plans, the roadmap, plans.db, or before starting any task tied to a plan.
---

# Plan System

The roadmap is one committed SQLite file, `plans.db`, at the repo root.
The `mind` MCP server serves it (`plans_*` tools). The file is the only
artifact: plans, dependencies, todos, and notes all live inside it. No
markdown, no YAML, nothing generated. A fresh clone already holds the
full history.

If the repo has no `plans.db`, this system does not apply here. Stop and
say so.

## Before plan work

1. Call `plans_show` (no arguments) for the board. With a name: the full
   record — goal, context, definition of done, steps, notes.
2. Call `plans_ready` for what is unblocked right now.

Respect `depends_on`. A plan starts only when its dependencies are
`done`.

## While you work

- Set `status: in_progress` with `plans_update` when you start.
- Work through `plans_todo_add` / `plans_todo_edit` (statuses:
  pending, in_progress, done). Todos are the plan's steps.
- Log decisions, findings, and open points with `plans_note_add` as
  they happen. Append-only; the next reader needs this context.
- `plans_show <name>` is the whole truth — never read or edit
  `plans.db` by hand.

## On completion

1. Run the review gate named in the plan's `review_type`
   (deep|quick|none): the `code-review` skill.
2. Set `status: done` plus the squash-merge commit with `plans_update`.
3. Commit `plans.db` as its own `chore(plans):` commit.

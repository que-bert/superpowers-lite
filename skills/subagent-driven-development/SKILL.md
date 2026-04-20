---
name: subagent-driven-development
description: Use when executing an approved implementation plan in the current session; this is the default execution path after writing-plans
---

# Subagent-Driven Development

Execute an approved implementation plan by dispatching a fresh subagent per task and reviewing each task before moving on.

## Default Execution Path

Default execution path: prefer this skill after `writing-plans` produces an approved plan, unless the user explicitly asks for inline execution.

## Preconditions

- the plan is approved
- the work is happening in an isolated branch or worktree
- tasks are mostly independent and can be reviewed one at a time

Use `executing-plans` instead when the user wants inline execution or when the work is too tightly coupled for the per-task subagent loop.

## Required Flow

1. Read the plan once, extract the tasks, and create tracking for them.
2. Before implementation, make sure the workspace setup matches `using-git-worktrees`.
3. For the current task, dispatch an implementer subagent with:
   - the full task text
   - relevant file and architecture context
   - explicit constraints
   - required verification commands
   - instructions to use `test-driven-development` for the task's code changes
4. Never make the subagent read the plan file itself. Provide the task text directly.
5. If the implementer returns `NEEDS_CONTEXT` or `BLOCKED`, resolve that before continuing.
6. When the implementer returns `DONE` or `DONE_WITH_CONCERNS`, run spec compliance review first.
7. If spec compliance review passes, run code quality review.
8. If either review fails, send the issues back to the implementer and repeat the loop.
9. Mark the task complete only after both reviews pass.
10. After all tasks pass, run a final review and then use `finishing-a-development-branch`.

## Review Order

The order is strict:

1. implementer
2. spec reviewer
3. code quality reviewer

Do not start code quality review before spec compliance review is approved.

## Model Selection

Default all implementation and review subagents to Sonnet.

- Implementer subagents: Sonnet
- Spec reviewer subagents: Sonnet
- Code quality reviewer subagents: Sonnet

Use a different model only when the user explicitly requests it or when the host environment enforces a different model policy.

## Implementer Status Handling

- `DONE`: proceed to spec review
- `DONE_WITH_CONCERNS`: read the concerns, resolve any real scope or correctness issue, then review
- `NEEDS_CONTEXT`: provide missing context and re-dispatch
- `BLOCKED`: change something before retrying: context, task size, model choice, or plan

Never ignore a blocked status and never re-run the same stuck task unchanged.

## Prompt Assets

Use these prompt files:

- `./implementer-prompt.md`
- `./spec-reviewer-prompt.md`
- `./code-quality-reviewer-prompt.md`

## Output Pattern

When coordinating the loop, keep updates concise:

```text
Task: [task name]
Implementer: [status]
Spec review: [pass/fail]
Code review: [pass/fail]
Next action: [fix, re-review, or complete]
```

## Red Flags

Never:

- run multiple implementer subagents in parallel on the same plan
- skip spec review
- skip code quality review
- let a review failure stand without a re-review
- let subagents invent scope beyond the task
- start work on main or master without explicit user consent

## Required Companion Skills

- `using-git-worktrees` before execution starts
- `test-driven-development` for implementer subagents during code changes
- `finishing-a-development-branch` after all tasks are done

## Next Skill

After all tasks are done, use `finishing-a-development-branch`.

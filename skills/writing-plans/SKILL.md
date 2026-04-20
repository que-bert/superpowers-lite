---
name: writing-plans
description: Use after an approved spec to write the implementation plan before touching code
---

# Writing Plans

Write a concrete implementation plan from an approved spec before code changes begin.

## Required Flow

1. Read the approved spec and verify the scope is still small enough for one plan.
2. Map the files that will be created or changed and the responsibility of each.
3. Break the work into small tasks and steps that can be executed and verified independently.
4. For every code-changing step, include the exact file paths, commands, and code the worker needs.
5. Save the plan to `docs/superpowers/plans/YYYY-MM-DD-<topic>.md`.
6. Self-review for spec coverage, placeholders, and naming consistency.
7. Offer execution choice: `subagent-driven-development` or `executing-plans`.

## Rules

- Assume the implementer has little project context.
- Prefer focused files and clear boundaries over large mixed-responsibility edits.
- Each step should be a single action that takes roughly 2-5 minutes.
- Use TDD structure when behavior changes: failing test, verify fail, minimal implementation, verify pass.
- Never use placeholders such as `TODO`, `TBD`, or "handle edge cases" without exact instructions.

## Output Templates

### Plan header template

```markdown
# [Feature Name] Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** [One sentence describing what this builds]

**Architecture:** [2-3 sentences about approach]

**Tech Stack:** [Key technologies/libraries]

---
```

### Task template

```markdown
### Task N: [Component Name]

**Files:**
- Create: `path/to/new-file`
- Modify: `path/to/existing-file`
- Test: `path/to/test-file`

- [ ] **Step 1: Write the failing test**
  Run: `[exact command]`
  Expected: `[expected failure]`

- [ ] **Step 2: Write the minimal implementation**
  Edit: `path/to/file`

- [ ] **Step 3: Verify the change**
  Run: `[exact command]`
  Expected: `[expected success]`
```

### Execution choice template

```text
Plan complete and saved to `docs/superpowers/plans/<filename>.md`.

Execution options:
1. Subagent-Driven (recommended) — use `subagent-driven-development`
2. Inline Execution — use `executing-plans`

Which approach do you want?
```

## Self-Review

Before handing off:

- confirm every spec requirement maps to one or more tasks
- remove placeholders and vague instructions
- make sure names, file paths, and commands stay consistent across tasks

## Next Skill

If the user chooses the default path, invoke `subagent-driven-development`. If they explicitly want inline execution, invoke `executing-plans`.

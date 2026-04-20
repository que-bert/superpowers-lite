# Superpowers-Lite Hybrid Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the expensive full-startup Superpowers bootstrap with a compact router while preserving the existing workflow pipeline and making `subagent-driven-development` default to Sonnet subagents.

**Architecture:** Keep the current plugin install shape and `SessionStart` hook, but change the hook to inject a new compact router document instead of the full `using-superpowers` skill. Keep the skill library intact, demote `using-superpowers` to reference/meta guidance, and update `subagent-driven-development` so implementer and reviewer subagents default to Sonnet.

**Tech Stack:** Claude Code plugin hooks, Markdown skill files, shell script bootstrap logic

**Spec:** `docs/superpowers/specs/2026-04-16-superpowers-lite-hybrid-design.md`

---

## File Structure

| File | Responsibility | Action |
|---|---|---|
| `bootstrap/claude-router.md` | Compact startup guidance for Claude Code | Create |
| `hooks/session-start` | Startup payload injection | Modify |
| `skills/using-superpowers/SKILL.md` | Meta/reference skill guidance | Modify |
| `skills/subagent-driven-development/SKILL.md` | Default implementation engine | Modify |
| `README.md` | Product and install documentation | Modify |

---

### Task 1: Add the compact startup router

**Files:**
- Create: `bootstrap/claude-router.md`

- [ ] **Step 1: Create the router file**

Add `bootstrap/claude-router.md` with this content:

```markdown
You have Superpowers workflow skills available.

Use them selectively but early when the task involves action, design,
implementation, debugging, review, or completion claims.

Default workflow:
- For new features, behavior changes, or open-ended solution work, use
  `brainstorming` first.
- After the design/spec is approved, use `writing-plans`.
- When executing an approved implementation plan, prefer
  `subagent-driven-development`.
- For bugs, failures, or unexpected behavior, use
  `systematic-debugging` before proposing fixes.
- Before claiming work is done, fixed, or passing, use
  `verification-before-completion`.
- After major implementation work or before merge, use
  `requesting-code-review`.

Do not force heavyweight workflow for simple informational tasks such as
explanation, summarization, lookup, or comparison, unless the task
turns into design or implementation work.

User instructions and project instructions override Superpowers workflow
guidance.
```

- [ ] **Step 2: Verify the file exists and content is exact**

Run:

```bash
sed -n '1,220p' bootstrap/claude-router.md
```

Expected:
- file exists
- text matches the intended compact router
- no platform-specific instructions or long doctrine content

- [ ] **Step 3: Commit**

```bash
git add bootstrap/claude-router.md
git commit -m "feat: add compact Claude startup router"
```

---

### Task 2: Change the startup hook to inject the compact router

**Files:**
- Modify: `hooks/session-start`

- [ ] **Step 1: Replace the full skill read with router read**

In `hooks/session-start`, replace the current read of
`skills/using-superpowers/SKILL.md`:

```bash
using_superpowers_content=$(cat "${PLUGIN_ROOT}/skills/using-superpowers/SKILL.md" 2>&1 || echo "Error reading using-superpowers skill")
```

with:

```bash
router_content=$(cat "${PLUGIN_ROOT}/bootstrap/claude-router.md" 2>&1 || echo "Error reading Claude router")
```

- [ ] **Step 2: Replace the payload variable names**

Replace:

```bash
using_superpowers_escaped=$(escape_for_json "$using_superpowers_content")
warning_escaped=$(escape_for_json "$warning_message")
session_context="<EXTREMELY_IMPORTANT>\nYou have superpowers.\n\n**Below is the full content of your 'superpowers:using-superpowers' skill - your introduction to using skills. For all other skills, use the 'Skill' tool:**\n\n${using_superpowers_escaped}\n\n${warning_escaped}\n</EXTREMELY_IMPORTANT>"
```

with:

```bash
router_escaped=$(escape_for_json "$router_content")
warning_escaped=$(escape_for_json "$warning_message")
session_context="<EXTREMELY_IMPORTANT>\nYou have superpowers.\n\n${router_escaped}\n\n${warning_escaped}\n</EXTREMELY_IMPORTANT>"
```

- [ ] **Step 3: Keep platform output logic unchanged**

Do not change the platform branching at the bottom of the file. Keep:

- Cursor output shape
- Claude Code `hookSpecificOutput.additionalContext`
- Copilot/SDK `additionalContext`

Only the payload content should change in this task.

- [ ] **Step 4: Verify the hook content**

Run:

```bash
sed -n '1,240p' hooks/session-start
```

Expected:
- `bootstrap/claude-router.md` is read
- `skills/using-superpowers/SKILL.md` is not read in the startup path
- output branching logic remains intact

- [ ] **Step 5: Commit**

```bash
git add hooks/session-start
git commit -m "feat: switch Claude startup bootstrap to compact router"
```

---

### Task 3: Demote `using-superpowers` from bootstrap doctrine to meta/reference guidance

**Files:**
- Modify: `skills/using-superpowers/SKILL.md`

- [ ] **Step 1: Rewrite the description**

Change the frontmatter description to clearly indicate this is meta guidance,
not startup bootstrap. Replace the current description with:

```yaml
description: Reference skill that explains how Superpowers workflows and skill activation work when explicit meta guidance is needed
```

- [ ] **Step 2: Rewrite the top section**

Replace the current opening doctrine-heavy section with a shorter version
that preserves the core rules but removes startup-specific framing.

Target opening:

```markdown
<SUBAGENT-STOP>
If you were dispatched as a subagent to execute a specific task, skip this skill.
</SUBAGENT-STOP>

## Purpose

This skill explains how Superpowers workflows fit together and when the
agent should activate them. It is reference guidance, not the default
startup bootstrap.

## Priority

1. User and project instructions
2. Activated Superpowers skills
3. Default model behavior

## Rule

When a task clearly matches a workflow skill, activate that skill before
proceeding.
```

- [ ] **Step 3: Keep useful sections, delete startup bloat**

Keep only the sections that still help as a reference skill:

- instruction priority
- how to access skills
- core rule
- skill priority

Remove or heavily shrink:

- long anti-rationalization tables
- full workflow graph intended for permanent injection
- repeated startup-enforcement phrasing

- [ ] **Step 4: Verify the result**

Run:

```bash
sed -n '1,220p' skills/using-superpowers/SKILL.md
wc -lcw skills/using-superpowers/SKILL.md
```

Expected:
- the file still explains the system
- the file is materially shorter than before
- the file no longer reads like a startup payload

- [ ] **Step 5: Commit**

```bash
git add skills/using-superpowers/SKILL.md
git commit -m "refactor: demote using-superpowers to reference guidance"
```

---

### Task 4: Make `subagent-driven-development` default to Sonnet subagents

**Files:**
- Modify: `skills/subagent-driven-development/SKILL.md`

- [ ] **Step 1: Replace the model-selection guidance**

Find the `## Model Selection` section and replace the current dynamic
guidance with:

```markdown
## Model Selection

Default all implementation and review subagents to Sonnet.

- Implementer subagents: Sonnet
- Spec reviewer subagents: Sonnet
- Code quality reviewer subagents: Sonnet

Use a different model only when the user explicitly requests it or when
the host environment enforces a different model policy.
```

- [ ] **Step 2: Verify no contradictory guidance remains**

Run:

```bash
rg -n "least powerful|cheap model|most capable|Sonnet" skills/subagent-driven-development/SKILL.md
```

Expected:
- old dynamic model-selection guidance is removed
- Sonnet default guidance is present
- no contradictory recommendations remain

- [ ] **Step 3: Commit**

```bash
git add skills/subagent-driven-development/SKILL.md
git commit -m "docs: default subagent-driven-development to Sonnet"
```

---

### Task 5: Update README to describe the lighter startup behavior

**Files:**
- Modify: `README.md`

- [ ] **Step 1: Update the opening explanation**

In the "How it works" section, add one short paragraph after the core
workflow description:

```markdown
Superpowers uses a compact startup router to steer the agent toward the
right workflow without injecting the full methodology into every
session. Informational requests stay light; design, implementation,
debugging, and completion work still trigger the full process.
```

- [ ] **Step 2: Update the basic workflow language**

Under "The Basic Workflow", update item 4 so that
`subagent-driven-development` is clearly the preferred execution path and
`executing-plans` is the fallback:

```markdown
4. **subagent-driven-development** - Default execution path for approved
plans. Dispatches fresh subagent per task with spec review and code
quality review.

5. **executing-plans** - Fallback execution mode when inline or batched
execution is preferable to the default subagent loop.
```

Renumber subsequent items accordingly.

- [ ] **Step 3: Verify the documentation**

Run:

```bash
sed -n '1,220p' README.md
```

Expected:
- README still describes easy installation
- README now reflects compact startup behavior
- README reflects `subagent-driven-development` as the default execution path

- [ ] **Step 4: Commit**

```bash
git add README.md
git commit -m "docs: describe compact startup router and default Sonnet path"
```

---

### Task 6: End-to-end verification

**Files:**
- Verify only

- [ ] **Step 1: Inspect the final diff**

Run:

```bash
git diff --stat HEAD~5 HEAD
git diff --name-only HEAD~5 HEAD
```

Expected:
- only the planned files changed
- no accidental install-surface complexity was introduced

- [ ] **Step 2: Verify startup payload no longer references full `using-superpowers`**

Run:

```bash
rg -n "using-superpowers/SKILL.md|bootstrap/claude-router.md" hooks/session-start
```

Expected:
- `bootstrap/claude-router.md` is referenced
- `using-superpowers/SKILL.md` is not referenced by the startup hook

- [ ] **Step 3: Verify Sonnet defaulting**

Run:

```bash
rg -n "Sonnet|least powerful|most capable|cheap model" skills/subagent-driven-development/SKILL.md
```

Expected:
- Sonnet defaulting is present
- old dynamic model-selection guidance is gone

- [ ] **Step 4: Request code review**

Use `superpowers:requesting-code-review` against the completed range before
declaring the change ready.

- [ ] **Step 5: Commit final polish if needed**

```bash
git status --short
```

Expected:
- clean working tree
- or only intentional follow-up fixes from review

---
name: using-superpowers
description: Reference skill that explains how Superpowers workflows and skill activation work when explicit meta guidance is needed
---

<SUBAGENT-STOP>
If you were dispatched as a subagent to execute a specific task, skip this skill.
</SUBAGENT-STOP>

## Purpose

This skill explains how Superpowers workflows fit together and when to
activate them. It is reference guidance, not the default startup
bootstrap.

## Instruction Priority

Superpowers guidance follows this priority order:

1. **User's explicit instructions** (CLAUDE.md, GEMINI.md, AGENTS.md, direct requests)
2. **Activated Superpowers skills**
3. **Default system prompt behavior**

If CLAUDE.md, GEMINI.md, or AGENTS.md says "don't use TDD" and a skill says "always use TDD," follow the user's instructions. The user is in control.

## How to Access Skills

**In Claude Code:** Use the `Skill` tool. When you invoke a skill, its content is loaded and presented to you—follow it directly. Never use the Read tool on skill files.

**In Copilot CLI:** Use the `skill` tool. Skills are auto-discovered from installed plugins. The `skill` tool works the same as Claude Code's `Skill` tool.

**In Gemini CLI:** Skills activate via the `activate_skill` tool. Gemini loads skill metadata at session start and activates the full content on demand.

**In other environments:** Check your platform's documentation for how skills are loaded.

## Platform Adaptation

Skills use Claude Code tool names. Non-CC platforms: see `references/copilot-tools.md` (Copilot CLI), `references/codex-tools.md` (Codex) for tool equivalents. Gemini CLI users get the tool mapping loaded automatically via GEMINI.md.

## Activation Rules

Activate a workflow skill before proceeding when the task clearly matches it.

- New features, behavior changes, or open-ended solution work:
  `brainstorming`
- Approved design or spec that needs an implementation plan:
  `writing-plans`
- Approved implementation plan that should be executed in-session:
  `subagent-driven-development`
- Bugs, failures, or unexpected behavior:
  `systematic-debugging`
- Major implementation work or pre-merge review:
  `requesting-code-review`
- Completion claims, "tests pass", "it's fixed", or "ready to merge":
  `verification-before-completion`

## Informational Requests

Keep explanation, summarization, lookup, and comparison requests light
unless they turn into design or implementation work.

## Skill Priority

When multiple skills could apply, prefer:

1. **Process skills first** (brainstorming, debugging) - these determine HOW to approach the task
2. **Implementation skills second** (frontend-design, mcp-builder) - these guide execution

"Let's build X" → brainstorming first, then implementation skills.
"Fix this bug" → debugging first, then domain-specific skills.

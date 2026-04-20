# Superpowers-Lite Hybrid Bootstrap Design

Replace the current Superpowers startup bootstrap with a compact adherence router that preserves the existing workflow pipeline while removing hot-path prompt bloat.

## Motivation

Current Superpowers works because it is forceful. The Claude plugin's `SessionStart` hook reads and injects the full `skills/using-superpowers/SKILL.md` content into every session. That produces strong first-turn adherence, but it also means every Claude session pays for a long doctrine document whether the user is building software or just asking for a summary.

The goal of `superpowers-lite` is not to remove the core product behavior. The goal is to keep the main value:

- clarifying questions before design-heavy work
- multiple approaches before commitment
- a written spec and implementation plan before non-trivial execution
- `subagent-driven-development` as the default execution path for approved plans
- code review and verification before completion claims

The change should remove unnecessary startup bloat and routing noise without weakening the action-oriented workflow that makes Superpowers valuable.

## Product Goals

`superpowers-lite` should replace current Superpowers as the default plugin behavior while keeping installation just as easy.

Target behavior:

- same one-step plugin installation shape for Claude Code
- same skill library availability for manual invocation
- same first-turn workflow steering for action-oriented work
- lighter behavior for informational requests
- same user/project instruction priority over plugin behavior

The product should still feel like "Superpowers, but less wasteful," not like a different methodology.

## Behavior Model

### Action-Oriented Tasks

For tasks involving design, implementation, behavior changes, debugging, review, or completion claims, Claude should be steered toward the existing Superpowers workflow:

1. `brainstorming`
2. `writing-plans`
3. `subagent-driven-development`
4. `requesting-code-review`
5. `verification-before-completion`

For debugging tasks, `systematic-debugging` should be the first enforced workflow.

### Informational Tasks

For requests such as explanation, summary, lookup, comparison, or code reading, Claude should not be forced through the heavyweight workflow path.

Informational tasks should escalate into workflow only if the interaction turns into design or implementation work.

### Subagent Execution

`subagent-driven-development` remains the default execution engine for approved implementation plans.

`executing-plans` remains available, but as an explicit fallback for cases where inline or lower-coordination execution is preferable.

## Architecture

The hybrid architecture keeps the existing plugin shape and skill library, but changes what runs on the hot path.

### Keep

- `.claude-plugin/plugin.json`
- `hooks/hooks.json`
- the existing skill library under `skills/`
- manual skill invocation
- autonomous skill discovery
- a `SessionStart` hook for Claude Code

### Change

- stop injecting the full `using-superpowers` skill at startup
- add a compact startup router file
- have `hooks/session-start` inject only the compact router
- keep `using-superpowers` in the repo, but remove it from the startup hot path

### Layer Model

#### Layer 1: Compact Startup Router

Always-on, small, injected at `SessionStart`.

Responsibilities:

- tell Claude when to use the core workflow skills
- distinguish action tasks from informational tasks
- preserve the default implementation path
- remind Claude that user/project instructions override plugin guidance

#### Layer 2: Core Workflow Skills

Loaded on demand.

These keep the detailed behavioral logic that currently gives Superpowers its value.

#### Layer 3: Meta and Reference Material

`using-superpowers` becomes reference/meta guidance rather than startup doctrine.

## Skill Surface Strategy

The plugin should continue to ship the full current skill library. Capability should not be reduced just to make routing simpler.

The optimization target is startup cost and routing quality, not the existence of additional skill files.

### Core Routed Path

The compact startup router should steer toward these skills by default:

- `brainstorming`
- `writing-plans`
- `subagent-driven-development`
- `systematic-debugging`
- `requesting-code-review`
- `verification-before-completion`
- `receiving-code-review`

### Secondary or Explicit-Use Skills

These should stay available, but should not be on the default hot path:

- `executing-plans`
- `dispatching-parallel-agents`
- `using-git-worktrees`
- `finishing-a-development-branch`
- `test-driven-development`
- `writing-skills`
- `using-superpowers`

This preserves capability while reducing routing ambiguity.

## Subagent Policy

`subagent-driven-development` should default to Sonnet subagents.

Default policy:

- implementer subagents use Sonnet
- spec reviewer subagents use Sonnet
- code quality reviewer subagents use Sonnet

Open-ended "least powerful model that can handle the task" guidance should not be the default. Predictable execution quality matters more than dynamic model selection for this workflow.

Advanced overrides may remain, but only as explicit opt-in guidance.

## Compact Startup Router Content

The new startup router should be short and directive:

```text
You have Superpowers workflow skills available.

Use them selectively but early when the task involves action, design, implementation, debugging, review, or completion claims.

Default workflow:
- For new features, behavior changes, or open-ended solution work, use `brainstorming` first.
- After the design/spec is approved, use `writing-plans`.
- When executing an approved implementation plan, prefer `subagent-driven-development`.
- For bugs, failures, or unexpected behavior, use `systematic-debugging` before proposing fixes.
- Before claiming work is done, fixed, or passing, use `verification-before-completion`.
- After major implementation work or before merge, use `requesting-code-review`.

Do not force heavyweight workflow for simple informational tasks such as explanation, summarization, lookup, or comparison, unless the task turns into design or implementation work.

User instructions and project instructions override Superpowers workflow guidance.
```

This should replace the current behavior of embedding the full `using-superpowers` skill into every session.

## Concrete File Changes

### 1. Replace Startup Payload

Modify:

- `hooks/session-start`

Add:

- `bootstrap/claude-router.md`

Change:

- stop reading `skills/using-superpowers/SKILL.md`
- read and inject `bootstrap/claude-router.md` instead

### 2. Keep but Demote `using-superpowers`

Modify:

- `skills/using-superpowers/SKILL.md`

Change:

- keep it as meta/reference guidance
- remove its role as always-on startup doctrine

### 3. Tighten Skill Descriptions

Modify descriptions and, where useful, first paragraphs for:

- `skills/brainstorming/SKILL.md`
- `skills/writing-plans/SKILL.md`
- `skills/subagent-driven-development/SKILL.md`
- `skills/systematic-debugging/SKILL.md`
- `skills/requesting-code-review/SKILL.md`
- `skills/verification-before-completion/SKILL.md`
- optional narrowing of secondary skills to reduce accidental routing

### 4. Pin `subagent-driven-development` to Sonnet

Modify:

- `skills/subagent-driven-development/SKILL.md`

Change:

- make Sonnet the default for implementer and reviewer subagents

### 5. Update Docs

Modify:

- `README.md`
- release notes if shipped as a user-visible behavior change

Document:

- compact startup routing
- lighter informational behavior
- preserved install simplicity

## Installation Requirements

The plugin must remain trivial to install.

For Claude Code, the user experience should remain a single plugin-install action. No extra local skill copy steps, no required `CLAUDE.md` customization, and no second plugin should be required.

If the package is published as `superpowers-lite`, it should still install as a single plugin and expose the same core value without further setup.

## Rollout Plan

### Phase 1: Local Branch

Implement:

- compact startup router
- startup hook rewrite
- Sonnet defaulting in `subagent-driven-development`

Leave larger skill-description cleanup as follow-up work if needed.

### Phase 2: Private Daily Use

Validate against real tasks:

- feature/build request
- bug/debugging request
- code review request
- simple informational request

### Phase 3: Public Branch or Repo

Publish a branch or fork once the behavior is stable and measurable.

### Phase 4: Upstream Candidate

If successful, this could become an upstream PR as:

- a compact bootstrap mode
- a lighter default startup behavior
- or a configurable startup adherence mode

## Success Criteria

The design succeeds if:

- installation remains one-step
- first-turn adherence remains strong for action-oriented work
- informational requests are lighter
- startup token cost materially drops
- `subagent-driven-development` becomes more predictable through Sonnet defaulting
- the product still feels like Superpowers

## First Implementation Slice

The first safe vertical slice is:

1. add `bootstrap/claude-router.md`
2. update `hooks/session-start` to inject it
3. stop injecting full `using-superpowers`
4. update `subagent-driven-development` to default to Sonnet
5. run behavioral checks

Only after that should broader skill-description cleanup be tackled, if still needed.

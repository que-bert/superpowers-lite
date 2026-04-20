---
name: brainstorming
description: Use when starting new features, behavior changes, or open-ended solution work that needs an approved spec before implementation
---

# Brainstorming

Turn ideas into an approved spec before any implementation work begins.

<HARD-GATE>
Do NOT invoke implementation skills, write code, or scaffold anything until you have presented a design and the user has approved it.
</HARD-GATE>

## Required Flow

1. Explore the current project state first: relevant files, docs, recent changes, and constraints.
2. If the request spans multiple independent subsystems, decompose it and brainstorm only the first slice.
3. Ask one clarifying question per message until the goal, constraints, and success criteria are clear.
4. Present 2-3 approaches with trade-offs and a recommendation.
5. Present the design in small sections and get approval.
6. Write the approved spec to `docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md`.
7. Self-review the spec for placeholders, contradictions, over-scope, and ambiguity.
8. Ask the user to review the written spec before moving to `using-git-worktrees`.

## Rules

- Ask one question at a time. Prefer multiple choice when practical.
- Stay in design mode. Do not slip into implementation advice or code.
- Follow existing codebase patterns when working in an existing project.
- Include only refactors that directly support the current goal.
- Keep the spec focused enough for a single implementation plan. If it is not, split it.

## Design Content

Cover only what the implementation will need:

- architecture and boundaries
- key components and responsibilities
- data flow and state changes
- error handling and constraints
- testing approach

## Output Templates

### Question message template

```text
I checked [context]. Before I design this, I need one decision:

[question]

If useful, here are options:
1. [option]
2. [option]

My recommendation: [recommendation]
```

### Approach options template

```text
I see [N] viable approaches:

1. [Approach A] — [trade-off]
2. [Approach B] — [trade-off]
3. [Approach C] — [trade-off]

I recommend [approach] because [reason].
```

### Design section template

```text
## [Section Name]

[2-6 sentences describing the design decision, boundaries, and trade-offs.]

Does this section look right so far?
```

### Spec handoff template

```text
Spec written to `docs/superpowers/specs/<filename>.md` and self-reviewed for gaps and ambiguity.

Please review it and tell me what you want changed before I move on to `using-git-worktrees` and then `writing-plans`.
```

## Visual Companion

If upcoming questions are inherently visual, offer the browser-based visual companion in its own message and follow `visual-companion.md`. Do not use it for ordinary text-only requirements questions.

## Next Skill

After the user approves the written spec, invoke `using-git-worktrees`. Once the isolated workspace is ready, invoke `writing-plans`. Do not jump directly to implementation.

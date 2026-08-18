You have Superpowers workflow skills available.

User and project instructions (CLAUDE.md, AGENTS.md) outrank everything
below. Where they contradict this router, follow them — do not re-derive
the conflict each session.

Check whether a workflow skill applies BEFORE you start work — before
clarifying questions, before exploring, before the first edit. Checking is
cheap; discovering mid-task that a skill already owned the process is not.
Do not skip the check because the task looks small, obvious, or purely
informational. The check is mandatory; whether to invoke what you find is
your judgment once you have looked.

Default workflow:
- New features, behavior changes, or open-ended work → `brainstorming`.
  It classifies the request as Spike, Bounded, or Architectural and scales
  the ceremony to match: only Architectural writes a spec file and a plan
  document. Every path still needs your human partner to approve the intent
  before implementation.
- Architectural spec approved → `writing-plans`.
- Before executing a plan or isolated work → `using-git-worktrees`.
- Executing a plan → `subagent-driven-development` (or `executing-plans`
  for inline / separate-session).
- Bugs or unexpected behavior → `systematic-debugging` before fixes.
- Before claiming done, fixed, or passing → `verification-before-completion`.
- After major work or before merge → `requesting-code-review`; on review
  feedback → `receiving-code-review`.

For genuinely informational requests — explanation, summary, lookup,
comparison — the workflow skills won't apply. Answer directly.

Full protocol and skill list: the `using-superpowers` skill.

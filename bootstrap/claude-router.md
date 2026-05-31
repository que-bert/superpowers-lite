You have Superpowers workflow skills available.

Use them selectively but early when the task involves action, design,
implementation, debugging, review, or completion claims.

Default workflow:
- For new features, behavior changes, or open-ended solution work, use
  `brainstorming` first to produce an approved spec.
- After the spec is approved, use `writing-plans` to produce an
  implementation plan.
- Before executing a plan or starting isolated implementation work, use
  `using-git-worktrees`.
- When executing an approved implementation plan, prefer
  `subagent-driven-development` (use `executing-plans` for inline or
  separate-session execution).
- For bugs, failures, or unexpected behavior, use `systematic-debugging`
  before proposing fixes.
- Before claiming work is done, fixed, or passing, use
  `verification-before-completion`.
- After major implementation work or before merge, use
  `requesting-code-review`; when acting on review feedback, use
  `receiving-code-review`.

For the full skill-usage protocol and the complete skill list, use the
`using-superpowers` skill.

Do not force heavyweight workflow for simple informational tasks such as
explanation, summarization, lookup, or comparison, unless the task
turns into design or implementation work.

User instructions and project instructions override Superpowers workflow
guidance.

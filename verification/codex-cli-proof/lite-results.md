# Lite Codex CLI Results

Candidate: `/home/work/git/superpowers/skills` at `b557648` plus current working-tree changes

## Scores

| Prompt | Result | Notes |
|---|---|---|
| `feature` | Pass | Starts with `brainstorming` and includes the full next path through spec approval, worktree, and planning |
| `approved_spec` | Pass | Correctly surfaces `using-git-worktrees` before `writing-plans` |
| `worktree` | Pass | Clearly requires isolated git worktree setup before planning or execution |
| `approved_plan` | Pass | Returns the current intended default: `subagent-driven-development` |
| `debugging` | Pass | Returns `systematic-debugging` |
| `review_request` | Pass | Returns `requesting-code-review` |
| `review_receive` | Pass | Returns `receiving-code-review` |
| `completion` | Pass | Returns `verification-before-completion` with fresh evidence requirement |
| `informational` | Pass | Keeps lightweight informational request light |
| `meta` | Pass | Explains current instruction priority and selective workflow activation |
| `adversarial_spec` | Pass | Refuses to skip isolation before planning |
| `adversarial_info` | Pass | Refuses to force heavyweight workflow for a quick comparison request |

## Observations

- Lite preserves all daily-use workflows in the prompt suite.
- Lite is less doctrinaire on startup but still routes Codex CLI prompts to the correct workflows.
- Lite is clearer than legacy on the current intended execution path because it names `subagent-driven-development` as the default after an approved plan.

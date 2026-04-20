# Legacy Codex CLI Results

Baseline: `/home/work/.codex/superpowers/skills` at commit `e4a2375`

## Scores

| Prompt | Result | Notes |
|---|---|---|
| `feature` | Pass | Starts with `brainstorming` and requires approved spec before implementation |
| `approved_spec` | Pass | Requires a dedicated worktree before `writing-plans`, though it describes it indirectly via `brainstorming` |
| `worktree` | Pass | Clearly requires isolated git worktree setup before planning or execution |
| `approved_plan` | Pass | Returns the legacy default: `executing-plans` |
| `debugging` | Pass | Returns `systematic-debugging` |
| `review_request` | Pass | Returns `requesting-code-review` |
| `review_receive` | Pass | Returns `receiving-code-review` |
| `completion` | Pass | Returns `verification-before-completion` with fresh evidence requirement |
| `informational` | Pass | Keeps lightweight informational request light |
| `meta` | Pass | Explains legacy `using-superpowers` instruction priority and always-check-for-skills posture |
| `adversarial_spec` | Pass | Refuses to skip isolation before planning |
| `adversarial_info` | Pass | Refuses to force heavyweight workflow for a quick comparison request |

## Observations

- Legacy preserves all daily-use workflows in the prompt suite.
- Legacy is more forceful and more likely to read `using-superpowers` before answering.
- Legacy still reflects the older execution default: `executing-plans` rather than `subagent-driven-development`.

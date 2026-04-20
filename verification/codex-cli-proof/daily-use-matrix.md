# Codex CLI Daily-Use Matrix

This matrix defines the daily-use functionality that the claim must preserve for Codex CLI.

## Required workflows

| Workflow | Minimum acceptable behavior |
|---|---|
| New feature / behavior change | Starts with `brainstorming` before implementation |
| Approved design/spec | Surfaces the default path toward `using-git-worktrees` and `writing-plans` |
| Worktree isolation | Identifies isolated git worktree setup as the default pre-planning / pre-execution step |
| Approved implementation plan | Uses `subagent-driven-development` as the default execution path |
| Debugging / failing tests | Uses `systematic-debugging` before proposing fixes |
| Requesting code review | Uses `requesting-code-review` after major implementation work / before merge |
| Receiving review feedback | Uses `receiving-code-review` before acting on questionable suggestions |
| Completion claims | Uses `verification-before-completion` and requires fresh verification evidence |
| Informational request | Keeps the response light and does not force the heavyweight workflow path |
| Explicit meta guidance | Can still explain how Superpowers workflows fit together when asked directly |

## Scoring rules

- `Pass`: names the correct skill or lightweight behavior and includes required follow-on guidance
- `Partial`: names the main skill correctly but omits an important default follow-on step
- `Fail`: names the wrong skill, over-routes a lightweight task, or misses the expected workflow entirely

## Claim threshold

- `Just as well`: lite matches or exceeds legacy on all required workflows and has no failures where legacy passes
- `If not better`: lite also improves informational-task lightness or routing precision without losing required workflow coverage

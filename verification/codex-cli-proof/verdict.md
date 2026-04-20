# Codex CLI Lite Proof Verdict

## Claim Under Test

`superpowers-lite works just as well if not better than superpowers with Codex CLI, and preserves the same daily-use functionality.`

## Result

For **Codex CLI**, this claim is **proven by the current side-by-side evidence** against the chosen legacy baseline.

## Why It Is Proven

### 1. Daily-use functionality is preserved

Both legacy and lite passed the same 12-prompt Codex CLI suite for:

- feature kickoff
- approved spec transition
- worktree isolation
- approved plan execution
- debugging
- requesting review
- receiving review feedback
- completion verification
- lightweight informational requests
- explicit meta guidance
- adversarial “skip worktree” pressure
- adversarial “force workflow on quick comparison” pressure

Lite had **no workflow loss** relative to legacy in this suite.

### 2. Lite is at least as good on the required workflows

Lite matched legacy on all required daily-use workflows:

- `brainstorming`
- `using-git-worktrees`
- `systematic-debugging`
- `requesting-code-review`
- `receiving-code-review`
- `verification-before-completion`
- keeping informational requests lightweight

There was **no prompt where legacy passed and lite failed**.

### 3. Lite is better on the default execution path

On the `approved_plan` prompt:

- legacy answered with `executing-plans`
- lite answered with `subagent-driven-development`

For the current Superpowers design, lite is the better result because the repo now treats `subagent-driven-development` as the default execution path after planning.

### 4. Lite is clearer on the approved-spec path

On the `approved_spec` prompt:

- legacy required a dedicated worktree before planning, but described it less directly
- lite explicitly said `using-git-worktrees` first, then `writing-plans`

That is a net clarity improvement in Codex CLI.

## Boundaries of the Proof

This verdict applies to:

- **Codex CLI**
- the specific legacy baseline at `/home/work/.codex/superpowers/skills` commit `e4a2375`
- the current lite checkout at `/home/work/git/superpowers/skills`
- the 12-prompt daily-use and adversarial suite in `prompt-suite.txt`

This verdict does **not** prove the broader cross-platform claim for:

- Codex App
- Claude Code
- other harnesses

Those need separate proof because the startup/bootstrap behavior differs by platform.

## Bottom Line

For **Codex CLI**, the evidence supports the strong claim:

- lite preserves the same daily-use functionality as legacy Superpowers
- lite performs at least as well across the tested workflow prompts
- lite performs better on the current default execution-path answer

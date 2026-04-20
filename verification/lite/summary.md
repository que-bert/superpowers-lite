# Superpowers Lite Verification Summary

## Conclusion

The lite version clearly reduces default startup context while maintaining the core Superpowers workflow contract. The reduction is directly measured, the repo-local lite policy tests pass fresh, and a live Codex smoke test against this checkout still resolves and uses the current Superpowers guidance correctly.

## What Was Verified Directly

### 1. Startup context is materially smaller

Measured on 2026-04-20:

- `bootstrap/claude-router.md`: 131 words, 1046 bytes
- `skills/using-superpowers/SKILL.md`: 383 words, 2836 bytes

That is a reduction of:

- 252 words
- 65.80% fewer words
- 1790 bytes
- 63.12% fewer bytes

This directly supports the claim that the lite path reduces default startup payload and context pressure.

### 2. Core workflow behavior is still enforced

Fresh repo-local tests passed:

- `tests/claude-code/test-session-start-router.sh`
- `tests/claude-code/test-superpowers-lite-static.sh`
- `tests/claude-code/run-skill-tests.sh`

Those checks verify that:

- the SessionStart hook injects compact router guidance
- the full `using-superpowers` bootstrap is no longer injected by default
- the router still includes `using-git-worktrees`
- the default workflow order is preserved
- `subagent-driven-development` still keeps `test-driven-development` as a companion discipline
- hot-path skills stay inside explicit size budgets

### 3. Live Codex usage still works against the current checkout

A fresh authenticated Codex smoke test was run against this checkout by temporarily pointing the global skill symlink at `/home/work/git/superpowers/skills`.

Observed results:

- Codex loaded `skills/using-superpowers/SKILL.md` from this repo
- Codex answered consistently with the current lite workflow
- the original global symlink was restored after the test

This is direct evidence that the current lite version still works in a real harness, not just static file inspection.

## What Is Maintained vs Improved

### Maintained

- workflow activation rules remain intact
- core routed skills remain documented and enforced
- TDD and worktree expectations remain present in the execution path
- Codex can still discover and use the current skill content

### Improved

- default startup payload is substantially smaller
- informational turns are explicitly kept lighter by the router design
- hot-path skill sizes are now guarded by repo-local tests

## Limits

Claude live runtime verification was attempted but blocked by local authentication:

- `Not logged in · Please run /login`

Because of that, the claim is strongest for:

- startup payload reduction
- repo-local workflow contract preservation
- current-checkout Codex usability

The Claude live-harness portion remains an environment gap rather than a product failure.

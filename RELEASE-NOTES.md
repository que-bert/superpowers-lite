# Superpowers Lite Release Notes

This file tracks fork-specific changes only. Upstream Superpowers history
still lives in the original project:

- https://github.com/obra/superpowers

## 2026-07-17

### Lossless re-sync to upstream v6.1.1

- `skills/` replaced byte-for-byte with upstream Superpowers `v6.1.1`
  (verified: `diff -rq` empty against the official plugin cache). Picks
  up the reworked `subagent-driven-development` (implementer/task-reviewer
  prompts + `scripts/` harness), `writing-skills`, `using-superpowers`,
  and drift in 10 other skills since `v5.1.0`.
- Version metadata bumped to `6.1.1` across plugin manifests and docs.
- Router unchanged (233 words). Both repo-local contract suites pass:
  `test-session-start-router.sh`, `test-superpowers-lite-static.sh`.
  Startup payload vs upstream 6.1.1 injection: 233 vs 481 words.

## 2026-05-30

### Lossless re-sync to upstream v5.1.0

- re-synced all 14 skills (and their supporting files) to be
  byte-identical to upstream `v5.1.0`. The previous fork state had
  condensed several skill bodies (brainstorming, systematic-debugging,
  writing-plans, subagent-driven-development, using-superpowers), which
  changed behavior; that condensing is reverted so skills function the
  same as upstream once invoked.
- reverted the `subagent-driven-development` Sonnet model pin back to
  upstream's role-based "least powerful model that can handle the task"
  guidance, so the workflow runs on all harnesses without a hard-coded
  model name.
- kept the one intentional efficiency change: the `SessionStart` hook
  injects the compact `bootstrap/claude-router.md` (~170 words) instead
  of the full `using-superpowers` skill (~790 words) — a 78% word / 75%
  byte reduction in startup payload. The full skill still loads on
  demand.
- corrected the router's workflow ordering to match upstream
  (brainstorming → writing-plans → using-git-worktrees → execution).
- bumped plugin/marketplace/package/gemini/cursor version metadata to
  `5.1.0` to reflect the synced base.

### Repo cleanup

- added a Claude Code install section to the README (previously only
  Codex and OpenCode were documented).
- fixed broken absolute `/home/work/...` links in `README.md`,
  `docs/README.codex.md`, and `docs/testing.md`.
- rewrote the lite contract tests to assert the new design (efficiency
  in the router; skills upstream-faithful and not model-pinned) instead
  of the old condensed-skill assertions.
- marked the earlier Codex CLI parity proof as historical (it was run
  against the previous fork state).

## 2026-04-20

### Fork documentation cleanup

- rewrote the root README so the repo presents itself as
  `superpowers-lite` instead of mirroring upstream copy
- replaced the inherited Codex and OpenCode guides with fork-specific
  install and compatibility notes
- replaced the generic testing guide with fork-specific verification
  guidance
- removed the inherited upstream release history from this repo's
  top-level release notes

### Verification and proof packaging

- kept root operational status files at `README.verification.md`,
  `progress.txt`, and `todo.json`
- stored verification outputs under `verification/`
- recorded the Codex CLI parity proof and lite startup-weight evidence in
  dedicated artifact directories

## 2026-04-16

### Lite router transition

- introduced the compact Claude startup router
- preserved the core workflow library while reducing startup prompt
  weight on the hot path
- kept `subagent-driven-development` as the preferred execution route
  when subagents are available

# Superpowers Lite Release Notes

This file tracks fork-specific changes only. Upstream Superpowers history
still lives in the original project:

- https://github.com/obra/superpowers

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

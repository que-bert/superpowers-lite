# Lite Verification README

This repo includes a small verification bundle for the current Superpowers lite path.

Top-level files:

- `README.verification.md` - this overview
- `progress.txt` - what was run and what happened
- `todo.json` - remaining work and environment gaps

Detailed artifacts live under:

- `verification/lite/summary.md`
- `verification/lite/metrics.txt`
- `verification/lite/codex-smoke.txt`
- `verification/lite/claude-checks.txt`

Headline result:

- default startup payload is materially smaller than the full `using-superpowers` bootstrap
- lite-specific repo-local tests pass fresh
- Codex smoke usage works against this checkout
- Claude live runtime validation is still blocked by local login state

Codex CLI proof bundle:

- `verification/codex-cli-proof/daily-use-matrix.md`
- `verification/codex-cli-proof/baseline.txt`
- `verification/codex-cli-proof/prompt-suite.txt`
- `verification/codex-cli-proof/legacy-results.md`
- `verification/codex-cli-proof/lite-results.md`
- `verification/codex-cli-proof/verdict.md`

Current proof status:

- `Codex CLI`: proven for the tested legacy baseline versus the current lite checkout
- broader cross-platform claim: not proven by this bundle

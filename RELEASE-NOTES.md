# Superpowers Lite Release Notes

This file tracks fork-specific changes only. Upstream Superpowers history
still lives in the original project:

- https://github.com/obra/superpowers

## 2026-08-18

### Lossless re-sync to upstream v6.3.0

- `skills/` replaced byte-for-byte with upstream Superpowers `v6.3.0`
  (verified: `diff -rq` empty against the official plugin cache). Picks up
  the reworked `brainstorming` (Spike / Bounded / Architectural paths —
  only Architectural writes a spec file and a plan document),
  `subagent-driven-development` ("Rulings, not stalls" plus a closed
  four-item stop list), `requesting-code-review` (reviewers may no longer
  dispatch their own subagents or second opinions), and safer worktree
  removal in `finishing-a-development-branch`.
- Version metadata bumped to `6.3.0` across plugin manifests.
  `gemini-extension.json` and `.cursor-plugin/plugin.json` had been left at
  `6.1.1` by earlier bumps and are now caught up; the fork-only `agents`
  and `commands` entries in the cursor manifest were preserved.

### Router: retired the 1%-rule form, kept the mandate

- `bootstrap/claude-router.md` (230 words, was 233). Fork-specific.
- **Precedence moved to the top.** It previously sat as the last line, in
  unmarked plain text, beneath an `<EXTREMELY-IMPORTANT>` block it
  cancelled — an inversion that put the strongest formatting behind the
  weakest claim.
- **Retired the "1% chance" / "STOP and check" absolutism.** Measured on a
  downstream user's config, the directive was overridden by user CLAUDE.md
  in every session, so it cost startup tokens to state a rule the next
  layer deleted. It also contradicted upstream `using-superpowers` itself,
  which says five lines after "you cannot rationalize your way out" that
  "if it turns out wrong for the situation, you don't have to use it."
  The replacement keeps the check mandatory and makes invocation a
  judgment call — which is what the upstream skill actually says.
- **Routing updated for 6.3.0.** The old text said "approved spec first"
  unconditionally; that is now true only on the Architectural path.
- The `SessionStart` wrapper tag is now `<superpowers-router>` rather than
  `<EXTREMELY_IMPORTANT>`, for the same salience reason.

### Test contract updates

Three assertions asserted retired upstream wording rather than behavior:

- router adherence: now asserts the pre-work check mandate and the
  precedence statement, not the literal "1% chance" string.
- `brainstorming` handoff: upstream made terminal states path-bound, so
  the flat "terminal state is invoking writing-plans" sentence is gone;
  the architectural-path contract is asserted instead, plus the new
  classification.
- `brainstorming` anti-pattern: renamed upstream from "Too Simple To Need
  A Design" to "Too Simple To Need Approval".

Suite status is unchanged by this release: `test-session-start-router.sh`
and `test-document-review-system.sh` pass. The three
`subagent-driven-development` suites and one `test-superpowers-lite-static`
assertion ("subagent workflow keeps TDD companion skill", "Includes spec
compliance review") were **already failing at the previous commit** and are
untouched here — they assert content upstream removed at or before `v6.2.0`
and need a separate decision about whether the fork still wants it.

### Verification numbers refreshed

README figures were measured against `v6.1.1` and had gone stale. Upstream
trimmed `using-superpowers` at `6.3.0`, so the router's advantage is real
but smaller: 230 vs 485 words (52.6% fewer), 1665 vs 3108 bytes (46.4%
fewer) — previously quoted as 78.1% / 74.9%.

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

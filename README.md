# Superpowers Lite

`superpowers-lite` is a fork of
[Superpowers](https://github.com/obra/superpowers) with one behavioral
change: it replaces the heavy startup injection with a compact router,
so every session pays less context up front. The skill library itself is
kept byte-for-byte in sync with upstream, so the workflow behaves the
same once a skill is actually invoked.

This repository is not trying to replace upstream history or community
docs. It documents the fork as it exists today: an upstream-faithful
skill library with a lighter startup path, plus fork-specific
verification and maintenance notes.

## Relationship To Upstream

Regular Superpowers lives at:

- https://github.com/obra/superpowers

Use upstream Superpowers if you want the original project, its release
cadence, its full documentation set, and its standard plugin-marketplace
install.

Use this fork if you want:

- the lighter startup router introduced here
- the same skills, kept in sync with upstream (currently `v6.1.1`)
- fork-specific verification artifacts and proof notes

The fork intentionally preserves upstream-compatible names where they
matter for installation and skill discovery. In a few places, names stay
`superpowers` on purpose so existing tooling keeps working.

## What This Fork Changes

The fork makes exactly one runtime change and keeps everything else
upstream:

- **Changed:** the `SessionStart` hook injects a compact router
  (`bootstrap/claude-router.md`, ~230 words) instead of the full
  `using-superpowers` skill (~485 words). The full skill is still
  available and loads on demand when invoked.
- **Unchanged:** all 14 skills are byte-identical to upstream `v6.3.0`.
  Nothing in any skill body is trimmed, reordered, or model-pinned. Once
  a skill runs, behavior matches upstream exactly.

This is the lossless part of the design: the efficiency comes only from
what is injected at startup, not from cutting skill content.

## Installation

Install for each harness you use.

### Claude Code

This fork is not on Anthropic's official marketplace, so install it from
this repository's bundled marketplace:

1. Register the marketplace:

   ```text
   /plugin marketplace add que-bert/superpowers-lite
   ```

2. Install the plugin (the plugin name stays `superpowers`; the
   marketplace name is `superpowers-dev`):

   ```text
   /plugin install superpowers@superpowers-dev
   ```

3. Restart Claude Code (or run `/plugin` to confirm it is enabled).

To install from a local clone instead:

```text
/plugin marketplace add /path/to/superpowers-lite
/plugin install superpowers@superpowers-dev
```

### Codex CLI

See the [Codex guide](docs/README.codex.md). In short, clone the fork and
expose its `skills/` directory on Codex's native discovery path
(`~/.agents/skills/superpowers`).

### OpenCode

See the [OpenCode guide](docs/README.opencode.md). In short, add
`superpowers@git+https://github.com/que-bert/superpowers-lite.git` to the
`plugin` array in `opencode.json`.

## Core Workflow Shape

The startup router steers the standard upstream workflow:

1. `brainstorming` for design and requirement clarification
2. `writing-plans` for an executable implementation plan
3. `using-git-worktrees` before isolated implementation work
4. `subagent-driven-development` as the preferred execution path when
   subagents are available (`executing-plans` for inline or
   separate-session execution)
5. `systematic-debugging` before proposing fixes
6. `requesting-code-review` / `receiving-code-review` around review
7. `verification-before-completion` before completion claims

### Full Skill Library

All upstream skills ship and are available for manual or autonomous
invocation, identical to upstream `v6.1.1`:

`brainstorming`, `writing-plans`, `using-git-worktrees`,
`subagent-driven-development`, `executing-plans`,
`dispatching-parallel-agents`, `systematic-debugging`,
`test-driven-development`, `requesting-code-review`,
`receiving-code-review`, `verification-before-completion`,
`finishing-a-development-branch`, `writing-skills`,
`using-superpowers`.

The router only changes which guidance is *injected at startup*. It does
not remove any skill from the library or change any skill's behavior.

## Current Verification Status

Measured on this checkout (router vs. the upstream startup injection):

- `bootstrap/claude-router.md`: 230 words, 1665 bytes
- `skills/using-superpowers/SKILL.md` (what upstream injects): 485 words,
  3108 bytes
- Startup payload reduction: **52.6% fewer words, 46.4% fewer bytes**

  The gap narrowed at `v6.3.0`: upstream trimmed `using-superpowers`
  substantially, so the router's advantage is real but smaller than the
  figures quoted here before 2026-08-18, which were measured against
  `v6.1.1` and had gone stale.

Repo-local contract tests (`tests/claude-code/`) verify that:

- the `SessionStart` hook injects the compact router, not the full
  `using-superpowers` skill
- the router preserves the upstream workflow ordering
- the skills are not condensed and the Sonnet model pin is not present
  (i.e., they match the upstream `v6.1.1` contract)

See [README.verification.md](README.verification.md) and the
[verification](verification/) directory. The earlier Codex CLI parity
proof in [verification/codex-cli-proof](verification/codex-cli-proof/)
was run against the previous fork state and is retained as history; it is
not a current claim.

## Repo Notes

- The repo name is `superpowers-lite`, but runtime-visible names stay
  `superpowers` for compatibility with plugin loaders and skill paths.
- Verification artifacts belong in the `verification/` directory.
- Root-level status files are intentionally small and operational:
  `README.verification.md`, `progress.txt`, and `todo.json`.

## Testing

See [docs/testing.md](docs/testing.md) for the testing and verification
workflow.

## Release Notes

Fork-specific release history lives in
[RELEASE-NOTES.md](RELEASE-NOTES.md).

## License

MIT License. See [LICENSE](LICENSE).

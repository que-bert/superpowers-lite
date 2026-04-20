# Superpowers Lite

`superpowers-lite` is a fork-focused, lower-overhead variant of
[Superpowers](https://github.com/obra/superpowers) that keeps the same
daily-use workflow shape while reducing startup prompt weight and making
the repo easier to maintain as a practical working fork.

This repository is not trying to replace upstream history or community
docs. It is documenting the fork as it exists today: a compatibility-
minded variant with lighter default routing, fork-specific verification,
and repo-local maintenance notes.

## Relationship To Upstream

Regular Superpowers lives at:

- https://github.com/obra/superpowers

Use upstream Superpowers if you want the original project, its release
cadence, and its full upstream documentation set.

Use this fork if you want:

- the lighter startup router introduced here
- fork-specific verification artifacts and proof notes
- docs that match this repo instead of mirroring upstream marketing copy

The fork still intentionally preserves important compatibility surfaces
where they matter for installation and skill discovery. In a few places,
names stay upstream-compatible on purpose so existing tooling keeps
working.

## What This Fork Changes

- Replaces the expensive full startup injection with a compact router for
  Claude-facing startup flows
- Keeps the same core workflow library available for explicit or routed
  use
- Prefers a smaller hot path while preserving the same daily-use skills
  people actually reach for
- Documents current proof boundaries instead of implying universal parity

## Current Verification Status

The strongest proof in this repo today is:

- Codex CLI daily-use workflow parity against the chosen legacy
  Superpowers baseline
- Lite startup context reduction for the Claude-side bootstrap path

Artifacts live under [verification](/home/work/git/superpowers/verification)
and the short summary is in
[README.verification.md](/home/work/git/superpowers/README.verification.md).

Important boundary:

- The Codex proof is for Codex CLI, not a blanket claim about every host
  or every future upstream revision.

## Core Workflow Shape

The default workflow remains recognizably Superpowers-style:

1. `brainstorming` for design and requirement clarification
2. `using-git-worktrees` before isolated implementation work
3. `writing-plans` for executable implementation plans
4. `subagent-driven-development` as the preferred execution path when
   subagents are available
5. `systematic-debugging` before proposing fixes
6. `requesting-code-review` and `verification-before-completion` before
   completion claims

### Core Routed Skills

These are the default hot-path skills the lite router is steering toward
for action-oriented work:

- **brainstorming** for design and requirement clarification
- **using-git-worktrees** before isolated implementation work
- **writing-plans** for executable implementation plans
- **subagent-driven-development** as the preferred execution path when
  subagents are available
- **systematic-debugging** before proposing fixes
- **requesting-code-review** before problems compound
- **verification-before-completion** before completion claims
- **receiving-code-review** when evaluating external review feedback

### Support Skills (manual or explicit use)

These remain available without being part of the default compact hot
path:

- **executing-plans** as the inline or fallback execution path
- **dispatching-parallel-agents** for explicit parallel work
- **finishing-a-development-branch** for merge or branch-completion
  decisions
- **test-driven-development** for Strict test-first discipline used inside implementation workflows
- **writing-skills** for skill authoring and validation
- **using-superpowers** as reference guidance

## Installation Guides

This fork keeps install guidance split by host so each document can be
accurate about compatibility details:

- [Codex guide](docs/README.codex.md)
- [OpenCode guide](docs/README.opencode.md)

If you are adapting this fork to another host, keep the runtime behavior
compatible first and then update the docs to match that host's real
installation story.

## Repo Notes

- The repo name is `superpowers-lite`, but some runtime-visible names are
  still `superpowers` for compatibility with existing plugin loaders and
  skill paths.
- Verification artifacts belong in the dedicated `verification/`
  directory.
- Root-level status files are intentionally small and operational:
  `README.verification.md`, `progress.txt`, and `todo.json`.

## Testing

For the current testing and verification workflow, see
[docs/testing.md](/home/work/git/superpowers/docs/testing.md).

## Release Notes

Fork-specific release history lives in
[RELEASE-NOTES.md](/home/work/git/superpowers/RELEASE-NOTES.md).

## License

MIT License. See [LICENSE](/home/work/git/superpowers/LICENSE).

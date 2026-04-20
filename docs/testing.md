# Testing Superpowers Lite

This repo keeps testing guidance focused on the fork's actual workflows
instead of inherited upstream prose.

## What To Verify

There are two distinct questions in this fork:

1. Does the lite startup path reduce prompt weight?
2. Does the fork still preserve the practical workflow coverage people
   use every day?

The current repo answers those questions with a mix of repo-local tests
and recorded verification artifacts.

## Repo-Local Test Commands

Run the current Claude-side skill and routing checks from the repo root:

```bash
bash tests/claude-code/test-session-start-router.sh
bash tests/claude-code/test-superpowers-lite-static.sh
bash tests/claude-code/run-skill-tests.sh
```

These cover the lite router split and the repo's current static skill
expectations.

## Verification Artifacts

The heavier proof artifacts live under
[verification](/home/work/git/superpowers/verification):

- `verification/lite/` for startup-weight reduction evidence
- `verification/codex-cli-proof/` for the Codex CLI daily-use proof

Start with:

- [README.verification.md](/home/work/git/superpowers/README.verification.md)
- [verification/lite/summary.md](/home/work/git/superpowers/verification/lite/summary.md)
- [verification/codex-cli-proof/verdict.md](/home/work/git/superpowers/verification/codex-cli-proof/verdict.md)

## Codex CLI Proof Scope

The Codex CLI proof in this repo is intentionally narrow and explicit:

- it compares this fork to a selected legacy Superpowers baseline
- it uses a fixed prompt suite for daily-use workflows
- it proves Codex CLI behavior only

Do not treat that proof as a blanket guarantee for every host or every
future upstream revision.

## When To Add New Verification

Add or refresh verification artifacts when you change:

- startup routing or bootstrap behavior
- the default execution path
- compatibility assumptions for Codex or Claude
- install docs that make runtime claims

Keep those artifacts in `verification/`, not at repo root.

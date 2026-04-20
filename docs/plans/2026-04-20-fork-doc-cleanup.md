# Superpowers Lite Fork Documentation Cleanup Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Replace inherited upstream-facing documentation with fork-specific documentation that accurately describes `superpowers-lite` while preserving compatibility guidance and a clear link back to upstream `superpowers`.

**Architecture:** Rewrite the small set of public-facing documentation files that define repo identity, install guidance, and release history. Keep internal plans and verification artifacts that explain the lite transition, but remove or overwrite inherited top-level docs that still present the repo as upstream `obra/superpowers`.

**Tech Stack:** Markdown docs, shell verification, git diff/search

---

### Task 1: Rewrite fork identity docs

**Files:**
- Modify: `README.md`
- Modify: `docs/README.codex.md`
- Modify: `docs/README.opencode.md`

**Step 1: Replace inherited upstream framing**

Rewrite each file so it identifies the repo as `superpowers-lite`, explains the relationship to upstream Superpowers, and uses fork-specific install/update guidance.

**Step 2: Preserve compatibility guidance**

Document where the fork intentionally keeps upstream-compatible names or paths, such as the Codex skills symlink name and the OpenCode package name.

**Step 3: Link upstream explicitly**

Add a short section linking to `https://github.com/obra/superpowers` and explain when a user should prefer upstream instead of this fork.

### Task 2: Rewrite inherited supporting docs

**Files:**
- Modify: `docs/testing.md`
- Modify: `RELEASE-NOTES.md`

**Step 1: Replace generic upstream testing narrative**

Rewrite the testing guide around this fork's current verification approach and existing repo-local test scripts.

**Step 2: Trim history to fork-relevant notes**

Replace the inherited upstream release log with a concise fork-specific change log covering the lite transition and verification work.

### Task 3: Verify no public-facing direct copies remain

**Files:**
- Verify: `README.md`
- Verify: `docs/README.codex.md`
- Verify: `docs/README.opencode.md`
- Verify: `docs/testing.md`
- Verify: `RELEASE-NOTES.md`

**Step 1: Search for upstream-only copy**

Run exact-string searches for old upstream branding, links, and copied sections across public-facing docs.

**Step 2: Compare against upstream docs where needed**

Use `git show upstream/main:<path>` and diff the rewritten files to confirm they are no longer direct copies.

**Step 3: Commit and push**

Create one commit for the doc cleanup and push the updated branch to `origin/main`.

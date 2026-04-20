# Superpowers Lite Documentation Scope Follow-Up Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Replace the remaining upstream-facing documentation and contributor-policy files with fork-specific versions, and remove unreferenced copied historical docs that are no longer needed by this fork.

**Architecture:** Update the remaining public and contributor-facing docs that still define the repo's identity or workflow, including install docs, community templates, and contributor guidance. Remove inherited historical plan docs that are no longer referenced and do not explain fork-specific behavior.

**Tech Stack:** Markdown docs, GitHub templates, shell verification, git audit commands

---

### Task 1: Rewrite remaining fork identity docs

**Files:**
- Modify: `CODE_OF_CONDUCT.md`
- Modify: `.codex/INSTALL.md`
- Modify: `.opencode/INSTALL.md`
- Modify: `.github/PULL_REQUEST_TEMPLATE.md`
- Modify: `.github/ISSUE_TEMPLATE/bug_report.md`
- Modify: `.github/ISSUE_TEMPLATE/feature_request.md`
- Modify: `.github/ISSUE_TEMPLATE/platform_support.md`
- Modify: `AGENTS.md`
- Modify: `CLAUDE.md`

**Step 1: Replace upstream-specific framing**

Update these files so they describe `superpowers-lite` as a maintained fork with explicit upstream relationship notes where useful.

**Step 2: Keep compatibility notes where needed**

Preserve installation and workflow details that intentionally keep upstream-compatible names or plugin identifiers.

**Step 3: Simplify contributor process for this fork**

Replace upstream maintainer-policy text with fork-specific expectations: honest scope, clear verification, and explicit distinction between fork-only and upstream-worthy changes.

### Task 2: Remove stale copied historical docs

**Files:**
- Delete: `docs/plans/2025-11-22-opencode-support-design.md`
- Delete: `docs/plans/2025-11-22-opencode-support-implementation.md`
- Delete: `docs/plans/2025-11-28-skills-improvements-from-user-feedback.md`
- Delete: `docs/plans/2026-01-17-visual-brainstorming.md`
- Delete: `docs/windows/polyglot-hooks.md`

**Step 1: Confirm they are unreferenced**

Search the repo for direct references before deletion.

**Step 2: Remove copied history that does not explain the fork**

Keep lite-transition and verification plans, but delete inherited upstream historical docs that are not required by the current fork.

### Task 3: Re-run the copy audit and verify

**Files:**
- Verify: public and contributor-facing docs

**Step 1: Run diff hygiene**

Run `git diff --check`.

**Step 2: Re-run identical-file audit**

Confirm the remaining identical files are implementation assets or intentionally retained internal references rather than fork identity docs.

**Step 3: Run repo checks and push**

Run the fast repo test suite, commit the cleanup, and push to `origin/main`.

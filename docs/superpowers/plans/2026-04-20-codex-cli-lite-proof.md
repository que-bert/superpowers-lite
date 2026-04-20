# Codex CLI Lite Proof Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Prove or disprove the claim that superpowers-lite works at least as well as legacy Superpowers for Codex CLI daily-use workflows.

**Architecture:** Use a side-by-side Codex CLI evaluation harness against two concrete skill trees: the legacy installed clone at `/home/work/.codex/superpowers/skills` and the current lite checkout at `/home/work/git/superpowers/skills`. Score both versions on the same daily-use prompt suite plus adversarial prompts, and only make the claim if lite matches or beats legacy on required workflow coverage while staying lighter on informational prompts.

**Tech Stack:** Codex CLI, bash, git, markdown, json

---

### Task 1: Define the proof surface and baseline

**Files:**
- Create: `verification/codex-cli-proof/daily-use-matrix.md`
- Create: `verification/codex-cli-proof/baseline.txt`
- Modify: `README.verification.md`

- [ ] **Step 1: Confirm the baseline and candidate**
  Run: `git -C /home/work/.codex/superpowers rev-parse --short HEAD && git -C /home/work/git/superpowers rev-parse --short HEAD`
  Expected: two distinct revisions or two distinct trees representing legacy and lite

- [ ] **Step 2: Define the daily-use workflow matrix**
  Edit: `verification/codex-cli-proof/daily-use-matrix.md`
  Include these workflow rows:
  - new feature / behavior change
  - approved spec
  - worktree isolation
  - approved implementation plan
  - failing tests / debugging
  - pre-merge review request
  - receiving review feedback
  - completion claim
  - lightweight informational request
  - explicit meta guidance / using-superpowers reference

- [ ] **Step 3: Define pass criteria**
  Edit: `verification/codex-cli-proof/baseline.txt`
  Include:
  - `just as well` = lite matches legacy on required workflow routing and preserves all daily-use workflows
  - `if not better` = lite also avoids unnecessary heavyweight routing on informational prompts, without losing required action routing

### Task 2: Run side-by-side Codex CLI evaluations

**Files:**
- Create: `verification/codex-cli-proof/legacy-results.md`
- Create: `verification/codex-cli-proof/lite-results.md`
- Create: `verification/codex-cli-proof/prompt-suite.txt`
- Create: `verification/codex-cli-proof/raw/legacy/*.txt`
- Create: `verification/codex-cli-proof/raw/lite/*.txt`

- [ ] **Step 1: Write the prompt suite**
  Edit: `verification/codex-cli-proof/prompt-suite.txt`
  Include exact prompts for each daily-use workflow plus at least two adversarial prompts:
  - approved spec path should surface worktree + planning, not skip isolation
  - informational request should stay light

- [ ] **Step 2: Run the legacy Codex CLI suite**
  Run: a shell script or loop that temporarily points `~/.agents/skills/superpowers` at `/home/work/.codex/superpowers/skills`, executes every prompt with `codex exec --ephemeral -m gpt-5.4-mini`, captures stdout per prompt, then restores the original symlink
  Expected: raw outputs saved under `verification/codex-cli-proof/raw/legacy/`

- [ ] **Step 3: Run the lite Codex CLI suite**
  Run: the same shell script or loop, but point `~/.agents/skills/superpowers` at `/home/work/git/superpowers/skills`
  Expected: raw outputs saved under `verification/codex-cli-proof/raw/lite/`

- [ ] **Step 4: Summarize both result sets**
  Edit: `verification/codex-cli-proof/legacy-results.md`
  Edit: `verification/codex-cli-proof/lite-results.md`
  For each prompt, record:
  - first workflow or answer surfaced
  - whether required follow-on steps were included
  - whether the answer over-routed or under-routed
  - whether the result supports daily-use parity

### Task 3: Score the claim and document the conclusion

**Files:**
- Create: `verification/codex-cli-proof/verdict.md`
- Modify: `progress.txt`
- Modify: `todo.json`
- Modify: `README.verification.md`

- [ ] **Step 1: Compare legacy versus lite**
  Edit: `verification/codex-cli-proof/verdict.md`
  For each prompt, mark:
  - legacy win
  - lite win
  - tie
  - inconclusive

- [ ] **Step 2: Decide the claim**
  Edit: `verification/codex-cli-proof/verdict.md`
  Use these rules:
  - If lite loses any required daily-use workflow that legacy gets right, the claim is disproven
  - If lite ties on all required workflows and wins on informational lightness, the claim is proven
  - If the result set is mixed, narrow the claim instead of overstating it

- [ ] **Step 3: Update root-level status files**
  Edit: `README.verification.md`
  Edit: `progress.txt`
  Edit: `todo.json`
  Add the Codex CLI proof status, exact limitations, and links to the new artifacts

- [ ] **Step 4: Verify artifact layout and JSON validity**
  Run: `ls -R verification/codex-cli-proof && jq . todo.json`
  Expected: all proof artifacts exist and `todo.json` remains valid

## Self-Review

- every daily-use workflow in the claim has a matching prompt
- legacy and lite are evaluated with the same prompt suite and same model
- the verdict criteria forbid hand-wavy “close enough” claims
- the final wording is narrower than the evidence if results are mixed

# Superpowers Lite Verification Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Verify that the lite startup path reduces default context usage while maintaining or improving practical Superpowers workflow behavior, and record the results in root-level summary files plus a dedicated verification artifacts folder.

**Architecture:** Use existing repo-local tests and direct file measurements for the static side, then run fresh harness checks where the environment allows for live evidence. Store detailed evidence under a dedicated root-level verification folder, and keep concise human-facing status files in the repo root.

**Tech Stack:** Bash, ripgrep, wc, Claude/Codex CLIs, Markdown, JSON

---

### Task 1: Gather static verification evidence

**Files:**
- Create: `verification/lite/summary.md`
- Create: `verification/lite/metrics.txt`
- Modify: `README.verification.md`
- Test: `tests/claude-code/test-session-start-router.sh`
- Test: `tests/claude-code/test-superpowers-lite-static.sh`
- Test: `tests/claude-code/run-skill-tests.sh`

**Step 1: Measure the startup payload reduction**

Run:

```bash
wc -w bootstrap/claude-router.md skills/using-superpowers/SKILL.md
wc -c bootstrap/claude-router.md skills/using-superpowers/SKILL.md
```

Expected:
- compact router is materially smaller than full `using-superpowers`
- measurements are recorded in `verification/lite/metrics.txt`

**Step 2: Re-run the static lite checks**

Run:

```bash
bash tests/claude-code/test-session-start-router.sh
bash tests/claude-code/test-superpowers-lite-static.sh
bash tests/claude-code/run-skill-tests.sh
```

Expected:
- session-start router test passes
- lite static policy test passes
- fast Claude suite passes

**Step 3: Summarize what the static evidence proves**

Write `verification/lite/summary.md` with:
- the measured payload reduction
- which workflow contracts are still enforced
- what static tests passed

**Step 4: Commit**

```bash
git add verification/lite/summary.md verification/lite/metrics.txt README.verification.md
git commit -m "docs: record lite static verification evidence"
```

### Task 2: Gather live harness evidence

**Files:**
- Modify: `verification/lite/summary.md`
- Create: `verification/lite/codex-smoke.txt`
- Create: `verification/lite/claude-checks.txt`
- Modify: `progress.txt`
- Modify: `todo.json`

**Step 1: Re-run a Codex smoke test against this checkout**

Run a minimal authenticated `codex exec` prompt against the current checkout and capture:
- whether the skill is loaded from this repo
- whether the answer matches current lite policy

Expected:
- Codex answers from the current `using-superpowers` content
- output saved to `verification/lite/codex-smoke.txt`

**Step 2: Attempt Claude live checks if available**

Run the lightest available Claude runtime checks.

Expected:
- if Claude auth is available, capture the pass result
- if Claude auth is unavailable, record the exact limitation in `verification/lite/claude-checks.txt` and `todo.json`

**Step 3: Update the verification summary**

Extend `verification/lite/summary.md` with:
- live harness results
- what was verified directly vs inferred from repo-local evidence
- any remaining gaps

**Step 4: Commit**

```bash
git add verification/lite/codex-smoke.txt verification/lite/claude-checks.txt verification/lite/summary.md progress.txt todo.json
git commit -m "docs: capture lite live verification results"
```

### Task 3: Publish root-level status files

**Files:**
- Create: `README.verification.md`
- Create: `progress.txt`
- Create: `todo.json`

**Step 1: Write the root README**

Create `README.verification.md` that:
- explains the verification goal
- points to the dedicated `verification/lite/` folder
- summarizes the headline result

**Step 2: Write progress tracking**

Create `progress.txt` with:
- completed commands
- current pass/fail status
- important environment notes

**Step 3: Write the remaining work list**

Create `todo.json` with:
- completed items
- pending items
- blockers or environment gaps

**Step 4: Verify the artifact layout**

Run:

```bash
ls -R verification
test -f README.verification.md
test -f progress.txt
test -f todo.json
```

Expected:
- root-level status files exist
- dedicated verification folder exists with detailed artifacts

**Step 5: Commit**

```bash
git add README.verification.md progress.txt todo.json verification
git commit -m "docs: add lite verification artifact bundle"
```

# Claude Code Skills Tests

Automated tests for Superpowers behavior in Claude Code environments.

## Overview

This test suite has two layers:

- Fast tests verify repo-local behavior such as hook output and skill file policy.
- Integration tests invoke Claude Code in headless mode against the local checkout plugin to verify runtime behavior without depending on a separately installed plugin.

## Requirements

- Claude Code CLI installed and in PATH (`claude --version` should work)
- Claude runtime authenticated (`claude --bare -p "hello"` should not return `Not logged in`)

## Running Tests

### Run all fast tests (recommended):
```bash
./run-skill-tests.sh
```

### Run integration tests (slow, environment-dependent):
```bash
./run-skill-tests.sh --integration
```

### Run specific test:
```bash
./run-skill-tests.sh --test test-subagent-driven-development.sh
```

### Run with verbose output:
```bash
./run-skill-tests.sh --verbose
```

### Set custom timeout:
```bash
./run-skill-tests.sh --timeout 1800  # 30 minutes for integration tests
```

## Test Structure

### test-helpers.sh
Common functions for Claude CLI integration testing:
- `require_claude_runtime` - Skip integration tests cleanly when Claude auth/runtime is unavailable
- `run_claude "prompt" [timeout]` - Run Claude against this checkout via `--bare --plugin-dir`
- `assert_contains output pattern name` - Verify pattern exists
- `assert_not_contains output pattern name` - Verify pattern absent
- `assert_count output pattern count name` - Verify exact count
- `assert_order output pattern_a pattern_b name` - Verify order
- `create_test_project` - Create temp test directory
- `create_test_plan project_dir` - Create sample plan file

### Test Files

Fast tests may read repo files or execute local scripts directly. Claude CLI
integration tests source `test-helpers.sh`, run `claude --bare --plugin-dir`
against this checkout with specific
prompts, and verify expected behavior using assertions.

## Example Test

```bash
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/test-helpers.sh"

echo "=== Test: My Skill ==="

# Ask Claude about the skill
output=$(run_claude "What does the my-skill skill do?" 30)

# Verify response
assert_contains "$output" "expected behavior" "Skill describes behavior"

echo "=== All tests passed ==="
```

## Current Tests

### Fast Tests (run by default)

#### test-session-start-router.sh
Tests the Claude SessionStart hook output directly:
- Emits Claude Code SessionStart payload
- Injects compact router guidance
- Does not inject the full `using-superpowers` bootstrap
- Does not leak raw skill-file paths

#### test-subagent-driven-development-static.sh
Tests repo-local policy in the skill file:
- `subagent-driven-development` is the default execution path
- Implementer and reviewer subagents default to Sonnet
- Worktree, spec review, and code quality review requirements remain documented

#### test-superpowers-lite-static.sh
Tests repo-local superpowers-lite policy:
- README documents the core-routed vs support-skill split
- `using-git-worktrees` remains in the default workflow
- `subagent-driven-development` keeps `test-driven-development` as a companion discipline
- `brainstorming` and `writing-plans` include explicit output templates
- Hot-path skills stay within the compact size budget

### Integration Tests (use --integration flag)

#### test-subagent-driven-development.sh
Claude CLI runtime smoke test:
- Asks Claude about the current checkout's skill definitions
- Verifies the described workflow order and policy
- Skips cleanly when Claude auth is unavailable

#### test-subagent-driven-development-integration.sh
Full workflow execution test (~10-30 minutes):
- Creates real test project with Node.js setup
- Creates implementation plan with 2 tasks
- Executes plan using subagent-driven-development
- Verifies actual behaviors:
  - Plan read once at start (not per task)
  - Full task text provided in subagent prompts
  - Spec compliance review happens before code quality
  - Working implementation is produced
  - Tests pass
  - Proper git commits created

**What it tests:**
- The workflow actually works end-to-end
- Our improvements are actually applied
- Subagents follow the skill correctly
- Final code is functional and tested

## Adding New Tests

1. Create new test file: `test-<skill-name>.sh`
2. If it needs Claude runtime behavior, source `test-helpers.sh`
3. Write assertions against either repo-local output or `run_claude`
4. Add fast deterministic tests to the default list in `run-skill-tests.sh`
5. Add environment-dependent Claude runtime checks under `--integration`

## Timeout Considerations

- Default timeout: 5 minutes per test
- Claude Code may take time to respond
- Adjust with `--timeout` if needed
- Tests should be focused to avoid long runs

## Debugging Failed Tests

With `--verbose`, you'll see full Claude output:
```bash
./run-skill-tests.sh --verbose --test test-subagent-driven-development.sh
```

Without verbose, only failures show output.

## CI/CD Integration

To run in CI:
```bash
# Run with explicit timeout for CI environments
./run-skill-tests.sh --timeout 900

# Exit code 0 = success, non-zero = failure
```

## Notes

- Prefer deterministic repo-local checks for the default fast suite
- Treat `claude -p` tests as integration coverage for local-plugin runtime behavior
- Full workflow tests are intentionally slower
- Focus on verifying stable workflow requirements, not incidental wording

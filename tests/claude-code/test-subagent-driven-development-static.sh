#!/usr/bin/env bash
# Test: subagent-driven-development skill file policy
# Verifies repo-local workflow defaults without depending on Claude CLI runtime
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_FILE="$SCRIPT_DIR/../../skills/subagent-driven-development/SKILL.md"

assert_contains() {
    local content="$1"
    local pattern="$2"
    local test_name="$3"

    if echo "$content" | grep -Eq "$pattern"; then
        echo "  [PASS] $test_name"
    else
        echo "  [FAIL] $test_name"
        echo "  Expected pattern: $pattern"
        exit 1
    fi
}

echo "=== Test: subagent-driven-development static policy ==="
echo ""

if [ ! -f "$SKILL_FILE" ]; then
    echo "  [FAIL] Skill file not found: $SKILL_FILE"
    exit 1
fi

content="$(cat "$SKILL_FILE")"

assert_lacks() {
    local content="$1" pattern="$2" test_name="$3"
    if echo "$content" | grep -Eq "$pattern"; then
        echo "  [FAIL] $test_name (unexpected: $pattern)"; exit 1
    else
        echo "  [PASS] $test_name"
    fi
}

echo "Test 1: Model policy is upstream-faithful (not pinned to Sonnet)..."
# The fork reverted the Sonnet pin so the workflow runs on all harnesses.
assert_lacks "$content" "Default all implementation and review subagents to Sonnet" "No Sonnet default-pin policy"
assert_lacks "$content" "Implementer subagents: Sonnet" "Implementers are not pinned to Sonnet"
echo ""

echo "Test 2: Two-stage review workflow is present..."
assert_contains "$content" "using-git-worktrees" "Requires worktree workflow"
assert_contains "$content" "spec compliance review" "Includes spec compliance review"
assert_contains "$content" "code quality review" "Includes code quality review"
assert_contains "$content" "test-driven-development" "Keeps TDD companion skill"
echo ""

echo "=== All static subagent-driven-development tests passed ==="

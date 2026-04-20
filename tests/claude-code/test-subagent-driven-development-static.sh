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

echo "Test 1: Default execution path..."
assert_contains "$content" "Default execution path.*prefer this skill" "Uses subagent-driven-development as default execution path"
echo ""

echo "Test 2: Sonnet defaults..."
assert_contains "$content" "Default all implementation and review subagents to Sonnet" "States Sonnet default policy"
assert_contains "$content" "Implementer subagents: Sonnet" "Implementers default to Sonnet"
assert_contains "$content" "Spec reviewer subagents: Sonnet" "Spec reviewers default to Sonnet"
assert_contains "$content" "Code quality reviewer subagents: Sonnet" "Code quality reviewers default to Sonnet"
echo ""

echo "Test 3: Workflow requirements..."
assert_contains "$content" "using-git-worktrees" "Requires worktree workflow"
assert_contains "$content" "spec compliance review" "Includes spec compliance review"
assert_contains "$content" "code quality review" "Includes code quality review"
echo ""

echo "=== All static subagent-driven-development tests passed ==="

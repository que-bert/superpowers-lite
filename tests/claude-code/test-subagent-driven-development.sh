#!/usr/bin/env bash
# Test: subagent-driven-development runtime behavior
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/test-helpers.sh"

echo "=== Test: subagent-driven-development skill ==="
echo ""

require_claude_runtime || {
    status=$?
    exit "$status"
}

echo "Test 1: Skill loading..."
output=$(run_claude "What is the subagent-driven-development skill? Describe its key steps briefly." 30)

if ! assert_contains "$output" "subagent-driven-development\|Subagent-Driven Development\|Subagent Driven" "Skill is recognized"; then
    exit 1
fi

if ! assert_contains "$output" "read.*plan\|extract.*tasks\|task.*tracking" "Mentions loading the plan and tasks"; then
    exit 1
fi

echo ""
echo "Test 2: Workflow ordering..."
output=$(run_claude "In the subagent-driven-development skill, what comes first: spec compliance review or code quality review? Be specific about the order." 30)

if ! assert_order "$output" "spec.*compliance" "code.*quality" "Spec compliance before code quality"; then
    exit 1
fi

echo ""
echo "Test 3: Task handoff..."
output=$(run_claude "In subagent-driven-development, how does the controller provide task information to the implementer subagent? Does it make them read a file or provide it directly?" 30)

if ! assert_contains "$output" "provide.*directly\|full.*task text\|full.*text\|include.*task" "Provides task text directly"; then
    exit 1
fi

if ! assert_not_contains "$output" "read.*plan file\|make.*subagent.*read.*file" "Does not make subagent read plan file"; then
    exit 1
fi

echo ""
echo "Test 4: Plan reading efficiency..."
output=$(run_claude "In subagent-driven-development, how many times should the controller read the plan file? When does this happen?" 30)

if ! assert_contains "$output" "once\|one time\|single" "Read plan once"; then
    exit 1
fi

if ! assert_contains "$output" "beginning\|start\|up front" "Read at the beginning"; then
    exit 1
fi

echo ""
echo "Test 5: Implementer status handling..."
output=$(run_claude "In subagent-driven-development, what should happen if the implementer returns NEEDS_CONTEXT or BLOCKED?" 30)

if ! assert_contains "$output" "provide.*context\|missing context\|resolve.*before continuing" "Needs context handled before continuing"; then
    exit 1
fi

if ! assert_contains "$output" "change something before retrying\|task size\|model choice\|plan\|blocked" "Blocked state requires a changed retry"; then
    exit 1
fi

echo ""
echo "Test 6: Review loop requirements..."
output=$(run_claude "In subagent-driven-development, what happens if a reviewer finds issues? Is it a one-time review or a loop?" 30)

if ! assert_contains "$output" "loop\|again\|repeat\|until.*pass\|until.*approved\|until.*review" "Review loops mentioned"; then
    exit 1
fi

if ! assert_contains "$output" "implementer.*fix\|fix.*issues" "Implementer fixes issues"; then
    exit 1
fi

echo ""
echo "Test 7: Worktree requirement..."
output=$(run_claude "What workflow skills are required before using subagent-driven-development? List any prerequisites or required skills." 30)

if ! assert_contains "$output" "using-git-worktrees\|worktree" "Mentions worktree requirement"; then
    exit 1
fi

echo ""
echo "Test 8: Main branch red flag..."
output=$(run_claude "In subagent-driven-development, is it okay to start implementation directly on the main branch?" 30)

if ! assert_contains "$output" "not.*main\|never.*main\|avoid.*main\|don't.*main\|consent\|permission\|branch" "Warns against main branch"; then
    exit 1
fi

echo ""
echo "Test 9: Sonnet default model policy..."
output=$(run_claude "In subagent-driven-development, what model should implementer and reviewer subagents use by default?" 30)

if ! assert_contains "$output" "Sonnet\|sonnet" "Defaults to Sonnet"; then
    exit 1
fi

if ! assert_not_contains "$output" "least powerful\|most capable available\|cheap model" "No old dynamic model guidance"; then
    exit 1
fi

echo ""
echo "=== All subagent-driven-development runtime tests passed ==="

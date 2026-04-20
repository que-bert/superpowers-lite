#!/usr/bin/env bash
# Test: superpowers-lite static policy
# Verifies repo-local skill contracts without depending on Claude CLI runtime
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

assert_file_contains() {
    local file="$1"
    local pattern="$2"
    local test_name="$3"

    if grep -Eq "$pattern" "$file"; then
        echo "  [PASS] $test_name"
    else
        echo "  [FAIL] $test_name"
        echo "  File: $file"
        echo "  Expected pattern: $pattern"
        exit 1
    fi
}

assert_max_words() {
    local file="$1"
    local max_words="$2"
    local test_name="$3"
    local words

    words="$(wc -w < "$file" | tr -d ' ')"

    if [ "$words" -le "$max_words" ]; then
        echo "  [PASS] $test_name ($words <= $max_words words)"
    else
        echo "  [FAIL] $test_name ($words > $max_words words)"
        echo "  File: $file"
        exit 1
    fi
}

README_FILE="$REPO_ROOT/README.md"
BRAINSTORMING_FILE="$REPO_ROOT/skills/brainstorming/SKILL.md"
WRITING_PLANS_FILE="$REPO_ROOT/skills/writing-plans/SKILL.md"
SYSTEMATIC_DEBUGGING_FILE="$REPO_ROOT/skills/systematic-debugging/SKILL.md"
SUBAGENT_FILE="$REPO_ROOT/skills/subagent-driven-development/SKILL.md"

echo "=== Test: superpowers-lite static policy ==="
echo ""

echo "Test 1: README documents core and support skill split..."
assert_file_contains "$README_FILE" "^### Core Routed Skills$" "README has core-routed section"
assert_file_contains "$README_FILE" "^### Support Skills \\(manual or explicit use\\)$" "README has support-skill section"
assert_file_contains "$README_FILE" "\\*\\*brainstorming\\*\\*" "README lists brainstorming as core"
assert_file_contains "$README_FILE" "\\*\\*using-git-worktrees\\*\\*" "README lists using-git-worktrees as core"
assert_file_contains "$README_FILE" "\\*\\*writing-plans\\*\\*" "README lists writing-plans as core"
assert_file_contains "$README_FILE" "\\*\\*subagent-driven-development\\*\\*" "README lists subagent-driven-development as core"
assert_file_contains "$README_FILE" "\\*\\*systematic-debugging\\*\\*" "README lists systematic-debugging as core"
assert_file_contains "$README_FILE" "\\*\\*executing-plans\\*\\*" "README lists executing-plans as support"
assert_file_contains "$README_FILE" "\\*\\*dispatching-parallel-agents\\*\\*" "README lists dispatching-parallel-agents as support"
assert_file_contains "$README_FILE" "Strict test-first discipline used inside implementation workflows" "README keeps TDD as implementation discipline"
echo ""

echo "Test 2: Default workflow ordering is preserved..."
assert_file_contains "$REPO_ROOT/bootstrap/claude-router.md" "using-git-worktrees" "router includes using-git-worktrees"
assert_file_contains "$BRAINSTORMING_FILE" "invoke .*using-git-worktrees" "brainstorming hands off to using-git-worktrees"
assert_file_contains "$SUBAGENT_FILE" "test-driven-development" "subagent workflow keeps TDD companion skill"
echo ""

echo "Test 3: Core skill output templates are present..."
assert_file_contains "$BRAINSTORMING_FILE" "^## Output Templates$" "brainstorming has output templates section"
assert_file_contains "$BRAINSTORMING_FILE" "Question message template" "brainstorming includes question template"
assert_file_contains "$BRAINSTORMING_FILE" "Approach options template" "brainstorming includes approach template"
assert_file_contains "$BRAINSTORMING_FILE" "Spec handoff template" "brainstorming includes spec handoff template"
assert_file_contains "$WRITING_PLANS_FILE" "^## Output Templates$" "writing-plans has output templates section"
assert_file_contains "$WRITING_PLANS_FILE" "Plan header template" "writing-plans includes plan header template"
assert_file_contains "$WRITING_PLANS_FILE" "Execution choice template" "writing-plans includes execution choice template"
echo ""

echo "Test 4: Hot-path skills stay compact..."
assert_max_words "$BRAINSTORMING_FILE" 1050 "brainstorming stays under hot-path budget"
assert_max_words "$WRITING_PLANS_FILE" 640 "writing-plans stays under hot-path budget"
assert_max_words "$SYSTEMATIC_DEBUGGING_FILE" 1050 "systematic-debugging stays under hot-path budget"
assert_max_words "$SUBAGENT_FILE" 1050 "subagent-driven-development stays under hot-path budget"
echo ""

echo "=== All superpowers-lite static policy tests passed ==="

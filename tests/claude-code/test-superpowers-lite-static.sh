#!/usr/bin/env bash
# Test: superpowers-lite static policy
#
# Verifies the lite design contract without depending on a Claude runtime:
#   1. Docs cover the fork identity and Claude Code install.
#   2. The compact router is the startup efficiency mechanism and keeps
#      the upstream workflow ordering.
#   3. Skills are upstream-faithful (NOT condensed, NOT model-pinned).
#   4. The startup payload is materially smaller than the upstream
#      using-superpowers injection.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

assert_file_contains() {
    local file="$1" pattern="$2" name="$3"
    if grep -Eq "$pattern" "$file"; then
        echo "  [PASS] $name"
    else
        echo "  [FAIL] $name"
        echo "         file: $file"
        echo "         expected pattern: $pattern"
        exit 1
    fi
}

assert_file_lacks() {
    local file="$1" pattern="$2" name="$3"
    if grep -Eq "$pattern" "$file"; then
        echo "  [FAIL] $name"
        echo "         file: $file"
        echo "         unexpected pattern present: $pattern"
        exit 1
    else
        echo "  [PASS] $name"
    fi
}

assert_max_words() {
    local file="$1" max="$2" name="$3" words
    words="$(wc -w < "$file" | tr -d ' ')"
    if [ "$words" -le "$max" ]; then
        echo "  [PASS] $name ($words <= $max words)"
    else
        echo "  [FAIL] $name ($words > $max words)"; exit 1
    fi
}

assert_min_words() {
    local file="$1" min="$2" name="$3" words
    words="$(wc -w < "$file" | tr -d ' ')"
    if [ "$words" -ge "$min" ]; then
        echo "  [PASS] $name ($words >= $min words)"
    else
        echo "  [FAIL] $name ($words < $min words) — skill looks condensed"; exit 1
    fi
}

README="$REPO_ROOT/README.md"
ROUTER="$REPO_ROOT/bootstrap/claude-router.md"
BRAINSTORMING="$REPO_ROOT/skills/brainstorming/SKILL.md"
SDD="$REPO_ROOT/skills/subagent-driven-development/SKILL.md"
SYSDEBUG="$REPO_ROOT/skills/systematic-debugging/SKILL.md"
USING="$REPO_ROOT/skills/using-superpowers/SKILL.md"

echo "=== Test: superpowers-lite static policy ==="
echo ""

echo "Test 1: README documents fork identity and Claude Code install..."
assert_file_contains "$README" "github.com/obra/superpowers" "README links upstream"
assert_file_contains "$README" "^### Claude Code$" "README has a Claude Code install section"
assert_file_contains "$README" "/plugin install superpowers@superpowers-dev" "README gives the Claude Code install command"
assert_file_contains "$README" "bootstrap/claude-router.md" "README documents the compact router as the change"
echo ""

echo "Test 2: Router is the compact efficiency mechanism with upstream ordering..."
for skill in brainstorming writing-plans using-git-worktrees subagent-driven-development systematic-debugging verification-before-completion requesting-code-review; do
    assert_file_contains "$ROUTER" "$skill" "router references $skill"
done
# Ordering: brainstorming -> writing-plans -> using-git-worktrees -> subagent-driven-development
order="$(grep -oE 'brainstorming|writing-plans|using-git-worktrees|subagent-driven-development' "$ROUTER" | awk '!seen[$0]++' | paste -sd, -)"
if [ "$order" = "brainstorming,writing-plans,using-git-worktrees,subagent-driven-development" ]; then
    echo "  [PASS] router preserves upstream workflow ordering ($order)"
else
    echo "  [FAIL] router ordering is $order"; exit 1
fi
assert_max_words "$ROUTER" 400 "router stays compact"
# The router carries the upstream adherence core so first-turn nagging
# survives the lighter startup payload.
assert_file_contains "$ROUTER" "1% chance" "router keeps the 1%-rule adherence pressure"
assert_file_contains "$ROUTER" "STOP and check" "router keeps the red-flag STOP table"
echo ""

echo "Test 3: Skills are upstream-faithful (not condensed, not model-pinned)..."
assert_file_contains "$BRAINSTORMING" "terminal state is invoking writing-plans" "brainstorming hands off to writing-plans (upstream contract)"
assert_file_contains "$BRAINSTORMING" "Too Simple To Need A Design" "brainstorming keeps the upstream anti-pattern guidance"
assert_file_contains "$SDD" "test-driven-development" "subagent workflow keeps TDD companion skill"
assert_file_lacks "$SDD" "Default all implementation and review subagents to Sonnet" "subagent workflow is NOT pinned to Sonnet"
assert_min_words "$SYSDEBUG" 1000 "systematic-debugging is full upstream content"
assert_min_words "$BRAINSTORMING" 1000 "brainstorming is full upstream content"
echo ""

echo "Test 4: Startup payload is smaller than the upstream injection..."
router_words="$(wc -w < "$ROUTER" | tr -d ' ')"
using_words="$(wc -w < "$USING" | tr -d ' ')"
if [ "$router_words" -lt "$using_words" ]; then
    echo "  [PASS] router ($router_words w) < using-superpowers ($using_words w)"
else
    echo "  [FAIL] router not smaller than using-superpowers"; exit 1
fi
echo ""

echo "=== All superpowers-lite static policy tests passed ==="

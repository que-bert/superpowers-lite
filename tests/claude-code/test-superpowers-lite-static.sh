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
# The router carries an adherence core so the check still happens on the
# first turn under the lighter startup payload. It asserts the MECHANISM,
# not the wording: the absolutist "1% chance / STOP and check" form was
# retired 2026-08-18 because it was contradicted by user CLAUDE.md every
# session, which inverted salience (an <EXTREMELY-IMPORTANT> block whose
# override was unmarked plain text). See RELEASE-NOTES.md.
assert_file_contains "$ROUTER" "BEFORE you start work" "router mandates a pre-work skill check"
assert_file_contains "$ROUTER" "check is mandatory" "router keeps the check non-optional"
# Precedence must be stated early, not buried, so it is not re-litigated.
assert_file_contains "$ROUTER" "outrank" "router states user/project precedence"
echo ""

echo "Test 3: Skills are upstream-faithful (not condensed, not model-pinned)..."
# Upstream 6.3.0 made terminal states path-bound (Spike / Bounded /
# Architectural), so the old flat "terminal state is invoking writing-plans"
# sentence is gone. The contract survives for the Architectural path; assert
# that, plus the classification itself, rather than the retired wording.
assert_file_contains "$BRAINSTORMING" "invoke after brainstorming is writing-plans" "brainstorming hands off to writing-plans (architectural path)"
assert_file_contains "$BRAINSTORMING" "Terminal states are path-bound" "brainstorming scales ceremony by path (6.3.0)"
# 6.3.0 renamed this section: the gate moved from "needs a design doc" to
# "needs approval", because ceremony is now path-scoped but approval is not.
assert_file_contains "$BRAINSTORMING" "Too Simple To Need Approval" "brainstorming keeps the upstream anti-pattern guidance"
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

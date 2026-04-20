#!/usr/bin/env bash
# Helper functions for Claude Code skill tests

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SKIP_EXIT_CODE=80

build_claude_cmd() {
    local prompt="$1"
    local tools="${2:-\"\"}"
    local allowed_tools="${3:-}"
    local extra_args="${4:-}"

    local cmd
    cmd="claude --bare --plugin-dir \"$REPO_ROOT\" -p \"$prompt\" --tools $tools"

    if [ -n "$allowed_tools" ]; then
        cmd="$cmd --allowed-tools=$allowed_tools"
    fi

    if [ -n "$extra_args" ]; then
        cmd="$cmd $extra_args"
    fi

    echo "$cmd"
}

require_claude_runtime() {
    local output_file
    output_file=$(mktemp)
    local cmd
    cmd=$(build_claude_cmd "Reply with READY only.")

    if timeout 20 bash -lc "$cmd" > "$output_file" 2>&1; then
        rm -f "$output_file"
        return 0
    fi

    local exit_code=$?
    local output
    output=$(cat "$output_file")
    rm -f "$output_file"

    if echo "$output" | grep -q "Not logged in"; then
        echo "SKIP: Claude runtime unavailable for integration tests: not logged in"
        return "$SKIP_EXIT_CODE"
    fi

    if [ "$exit_code" -eq 124 ]; then
        echo "SKIP: Claude runtime unavailable for integration tests: readiness check timed out"
        return "$SKIP_EXIT_CODE"
    fi

    echo "ERROR: Claude runtime readiness check failed"
    echo "$output"
    return 1
}

# Run Claude Code with a prompt and capture output against the local repo plugin.
# Usage: run_claude "prompt text" [timeout_seconds] [allowed_tools] [tools] [extra_args]
run_claude() {
    local prompt="$1"
    local timeout="${2:-60}"
    local allowed_tools="${3:-}"
    local tools="${4:-\"\"}"
    local extra_args="${5:-}"
    local output_file
    output_file=$(mktemp)

    local cmd
    cmd=$(build_claude_cmd "$prompt" "$tools" "$allowed_tools" "$extra_args")

    if timeout "$timeout" bash -lc "$cmd" > "$output_file" 2>&1; then
        cat "$output_file"
        rm -f "$output_file"
        return 0
    fi

    local exit_code=$?
    local output
    output=$(cat "$output_file")
    rm -f "$output_file"

    if echo "$output" | grep -q "Not logged in"; then
        echo "SKIP: Claude runtime unavailable for integration tests: not logged in" >&2
        return "$SKIP_EXIT_CODE"
    fi

    echo "$output" >&2
    return "$exit_code"
}

# Check if output contains a pattern
# Usage: assert_contains "output" "pattern" "test name"
assert_contains() {
    local output="$1"
    local pattern="$2"
    local test_name="${3:-test}"

    if echo "$output" | grep -q "$pattern"; then
        echo "  [PASS] $test_name"
        return 0
    else
        echo "  [FAIL] $test_name"
        echo "  Expected to find: $pattern"
        echo "  In output:"
        echo "$output" | sed 's/^/    /'
        return 1
    fi
}

# Check if output does NOT contain a pattern
# Usage: assert_not_contains "output" "pattern" "test name"
assert_not_contains() {
    local output="$1"
    local pattern="$2"
    local test_name="${3:-test}"

    if echo "$output" | grep -q "$pattern"; then
        echo "  [FAIL] $test_name"
        echo "  Did not expect to find: $pattern"
        echo "  In output:"
        echo "$output" | sed 's/^/    /'
        return 1
    else
        echo "  [PASS] $test_name"
        return 0
    fi
}

# Check if output matches a count
# Usage: assert_count "output" "pattern" expected_count "test name"
assert_count() {
    local output="$1"
    local pattern="$2"
    local expected="$3"
    local test_name="${4:-test}"

    local actual
    actual=$(echo "$output" | grep -c "$pattern" || echo "0")

    if [ "$actual" -eq "$expected" ]; then
        echo "  [PASS] $test_name (found $actual instances)"
        return 0
    else
        echo "  [FAIL] $test_name"
        echo "  Expected $expected instances of: $pattern"
        echo "  Found $actual instances"
        echo "  In output:"
        echo "$output" | sed 's/^/    /'
        return 1
    fi
}

# Check if pattern A appears before pattern B
# Usage: assert_order "output" "pattern_a" "pattern_b" "test name"
assert_order() {
    local output="$1"
    local pattern_a="$2"
    local pattern_b="$3"
    local test_name="${4:-test}"

    local line_a
    local line_b
    line_a=$(echo "$output" | grep -n "$pattern_a" | head -1 | cut -d: -f1)
    line_b=$(echo "$output" | grep -n "$pattern_b" | head -1 | cut -d: -f1)

    if [ -z "$line_a" ]; then
        echo "  [FAIL] $test_name: pattern A not found: $pattern_a"
        return 1
    fi

    if [ -z "$line_b" ]; then
        echo "  [FAIL] $test_name: pattern B not found: $pattern_b"
        return 1
    fi

    if [ "$line_a" -lt "$line_b" ]; then
        echo "  [PASS] $test_name (A at line $line_a, B at line $line_b)"
        return 0
    else
        echo "  [FAIL] $test_name"
        echo "  Expected '$pattern_a' before '$pattern_b'"
        echo "  But found A at line $line_a, B at line $line_b"
        return 1
    fi
}

# Create a temporary test project directory
create_test_project() {
    local test_dir
    test_dir=$(mktemp -d)
    echo "$test_dir"
}

# Cleanup test project
cleanup_test_project() {
    local test_dir="$1"
    if [ -d "$test_dir" ]; then
        rm -rf "$test_dir"
    fi
}

# Create a simple plan file for testing
create_test_plan() {
    local project_dir="$1"
    local plan_name="${2:-test-plan}"
    local plan_file="$project_dir/docs/superpowers/plans/$plan_name.md"

    mkdir -p "$(dirname "$plan_file")"

    cat > "$plan_file" <<'EOF'
# Test Implementation Plan

## Task 1: Create Hello Function

Create a simple hello function that returns "Hello, World!".

**File:** `src/hello.js`

**Implementation:**
```javascript
export function hello() {
  return "Hello, World!";
}
```

**Tests:** Write a test that verifies the function returns the expected string.

**Verification:** `npm test`

## Task 2: Create Goodbye Function

Create a goodbye function that takes a name and returns a goodbye message.

**File:** `src/goodbye.js`

**Implementation:**
```javascript
export function goodbye(name) {
  return `Goodbye, ${name}!`;
}
```

**Tests:** Write tests for:
- Default name
- Custom name
- Edge cases (empty string, null)

**Verification:** `npm test`
EOF

    echo "$plan_file"
}

export -f run_claude
export -f require_claude_runtime
export -f assert_contains
export -f assert_not_contains
export -f assert_count
export -f assert_order
export -f create_test_project
export -f cleanup_test_project
export -f create_test_plan

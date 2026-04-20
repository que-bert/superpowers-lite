#!/usr/bin/env bash
# Test runner for Claude Code skills
# Tests skills by invoking Claude Code CLI and verifying behavior
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

echo "========================================"
echo " Claude Code Skills Test Suite"
echo "========================================"
echo ""
echo "Repository: $(cd ../.. && pwd)"
echo "Test time: $(date)"
echo "Claude version: $(claude --version 2>/dev/null || echo 'not found')"
echo ""

# Check if Claude Code is available
if ! command -v claude &> /dev/null; then
    echo "ERROR: Claude Code CLI not found"
    echo "Install Claude Code first: https://code.claude.com"
    exit 1
fi

# Parse command line arguments
VERBOSE=false
SPECIFIC_TEST=""
TIMEOUT=300  # Default 5 minute timeout per test
RUN_INTEGRATION=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --verbose|-v)
            VERBOSE=true
            shift
            ;;
        --test|-t)
            SPECIFIC_TEST="$2"
            shift 2
            ;;
        --timeout)
            TIMEOUT="$2"
            shift 2
            ;;
        --integration|-i)
            RUN_INTEGRATION=true
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [options]"
            echo ""
            echo "Options:"
            echo "  --verbose, -v        Show verbose output"
            echo "  --test, -t NAME      Run only the specified test"
            echo "  --timeout SECONDS    Set timeout per test (default: 300)"
            echo "  --integration, -i    Run integration tests (slow, environment-dependent)"
            echo "  --help, -h           Show this help"
            echo ""
            echo "Tests:"
            echo "  test-session-start-router.sh                 Test compact SessionStart payload"
            echo "  test-superpowers-lite-static.sh             Test core/support split and hot-path budgets"
            echo "  test-subagent-driven-development-static.sh   Test skill file policy and defaults"
            echo ""
            echo "Integration Tests (use --integration):"
            echo "  test-subagent-driven-development.sh          Claude CLI skill behavior"
            echo "  test-subagent-driven-development-integration.sh  Full workflow execution"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# List of skill tests to run (fast unit tests)
tests=(
    "test-session-start-router.sh"
    "test-superpowers-lite-static.sh"
    "test-subagent-driven-development-static.sh"
)

# Integration tests (slow, full execution)
integration_tests=(
    "test-subagent-driven-development.sh"
    "test-subagent-driven-development-integration.sh"
)

# Add integration tests if requested
if [ "$RUN_INTEGRATION" = true ]; then
    tests+=("${integration_tests[@]}")
fi

# Filter to specific test if requested
if [ -n "$SPECIFIC_TEST" ]; then
    tests=("$SPECIFIC_TEST")
fi

# Track results
passed=0
failed=0
skipped=0
SKIP_EXIT_CODE=80

# Run each test
for test in "${tests[@]}"; do
    echo "----------------------------------------"
    echo "Running: $test"
    echo "----------------------------------------"

    test_path="$SCRIPT_DIR/$test"

    if [ ! -f "$test_path" ]; then
        echo "  [SKIP] Test file not found: $test"
        skipped=$((skipped + 1))
        continue
    fi

    start_time=$(date +%s)

    if [ "$VERBOSE" = true ]; then
        if timeout "$TIMEOUT" bash "$test_path"; then
            end_time=$(date +%s)
            duration=$((end_time - start_time))
            echo ""
            echo "  [PASS] $test (${duration}s)"
            passed=$((passed + 1))
        else
            exit_code=$?
            end_time=$(date +%s)
            duration=$((end_time - start_time))
            echo ""
            if [ $exit_code -eq $SKIP_EXIT_CODE ]; then
                echo "  [SKIP] $test (${duration}s)"
                skipped=$((skipped + 1))
            elif [ $exit_code -eq 124 ]; then
                echo "  [FAIL] $test (timeout after ${TIMEOUT}s)"
                failed=$((failed + 1))
            else
                echo "  [FAIL] $test (${duration}s)"
                failed=$((failed + 1))
            fi
        fi
    else
        # Capture output for non-verbose mode
        if output=$(timeout "$TIMEOUT" bash "$test_path" 2>&1); then
            end_time=$(date +%s)
            duration=$((end_time - start_time))
            echo "  [PASS] (${duration}s)"
            passed=$((passed + 1))
        else
            exit_code=$?
            end_time=$(date +%s)
            duration=$((end_time - start_time))
            if [ $exit_code -eq $SKIP_EXIT_CODE ]; then
                echo "  [SKIP] (${duration}s)"
                skipped=$((skipped + 1))
            elif [ $exit_code -eq 124 ]; then
                echo "  [FAIL] (timeout after ${TIMEOUT}s)"
                failed=$((failed + 1))
            else
                echo "  [FAIL] (${duration}s)"
                failed=$((failed + 1))
            fi
            echo ""
            echo "  Output:"
            echo "$output" | sed 's/^/    /'
        fi
    fi

    echo ""
done

# Print summary
echo "========================================"
echo " Test Results Summary"
echo "========================================"
echo ""
echo "  Passed:  $passed"
echo "  Failed:  $failed"
echo "  Skipped: $skipped"
echo ""

if [ "$RUN_INTEGRATION" = false ] && [ ${#integration_tests[@]} -gt 0 ]; then
    echo "Note: Integration tests were not run."
    echo "Use --integration flag to run Claude CLI and full workflow execution tests."
    echo ""
fi

if [ $failed -gt 0 ]; then
    echo "STATUS: FAILED"
    exit 1
else
    echo "STATUS: PASSED"
    exit 0
fi

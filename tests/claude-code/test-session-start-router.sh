#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "=== Test: SessionStart uses compact router payload ==="

output=$(CLAUDE_PLUGIN_ROOT=1 "$REPO_ROOT/hooks/session-start")

if echo "$output" | grep -q '"hookEventName": "SessionStart"'; then
    echo "  [PASS] emits Claude Code SessionStart payload"
else
    echo "  [FAIL] missing Claude Code SessionStart payload"
    echo "$output" | sed 's/^/    /'
    exit 1
fi

if echo "$output" | grep -q "Default workflow:"; then
    echo "  [PASS] injects compact router guidance"
else
    echo "  [FAIL] missing compact router guidance"
    echo "$output" | sed 's/^/    /'
    exit 1
fi

if echo "$output" | grep -q "Below is the full content of your 'superpowers:using-superpowers' skill"; then
    echo "  [FAIL] still injects full using-superpowers bootstrap"
    echo "$output" | sed 's/^/    /'
    exit 1
else
    echo "  [PASS] no full using-superpowers bootstrap"
fi

if echo "$output" | grep -q 'skills/using-superpowers/SKILL.md'; then
    echo "  [FAIL] leaked raw using-superpowers file path"
    echo "$output" | sed 's/^/    /'
    exit 1
else
    echo "  [PASS] no raw using-superpowers path leakage"
fi

echo "=== All tests passed ==="

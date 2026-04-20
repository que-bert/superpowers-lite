---
name: systematic-debugging
description: Use for bugs, test failures, build failures, or unexpected behavior that require root-cause investigation before fixes
---

# Systematic Debugging

Find the root cause before proposing or implementing fixes.

## Iron Law

```text
NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST
```

If you have not finished investigation, you are not ready to fix the issue.

## When to Use

Use this for:

- failing tests
- runtime bugs
- build or CI failures
- integration issues
- performance regressions
- any unexpected technical behavior

Use it especially when the issue looks "obvious," you are under time pressure, or previous fixes have already failed.

## Four Phases

### 1. Investigate

Collect evidence before changing code:

- read the full error output, stack trace, and warnings
- reproduce the problem consistently
- check recent code, config, dependency, or environment changes
- note the exact failing inputs, commands, and conditions

For multi-component systems, instrument each boundary before proposing fixes:

- log what enters the component
- log what exits the component
- verify config and environment propagation
- identify the first layer where reality diverges from expectation

If the bad value appears deep in the stack, trace it backward to the first bad source. Fix the source, not the downstream symptom.

### 2. Compare

Look for a working reference before inventing a fix:

- find similar working code in the same codebase
- compare the broken path with the working path
- list concrete differences
- identify hidden assumptions, dependencies, or required setup

### 3. Hypothesize

Form one clear hypothesis at a time:

- state what you think is wrong and why
- make the smallest possible change or experiment to test it
- change one variable at a time
- if the hypothesis fails, discard it and return to investigation

Do not stack fixes or continue forward on a weak hypothesis.

### 4. Fix and Verify

Once the root cause is supported by evidence:

- create the smallest failing test or reproduction
- implement one fix for the identified cause
- run the targeted verification
- run broader verification needed to catch regressions

If the fix fails, stop and return to investigation with the new evidence.

## Three-Fail Rule

If you have already tried three fixes and the problem keeps moving, stop treating it as a local bug. That usually indicates an architectural problem, hidden coupling, or a bad assumption in the overall design. Escalate the architectural question before attempting a fourth fix.

## Red Flags

Stop and restart the process if you catch yourself:

- proposing fixes before reproducing the issue
- guessing without evidence
- changing multiple things at once
- skipping the failing test or reproduction
- adapting a reference implementation you have not fully read
- adding "one more fix" after repeated failures

## Output Pattern

When reporting progress, prefer this structure:

```text
Issue: [what is failing]
Evidence: [what you observed]
Working comparison: [what behaves correctly]
Hypothesis: [single root-cause hypothesis]
Next check or fix: [smallest validating action]
```

## Next Skill

When you are ready to implement the fix, use `test-driven-development` for the code change and `verification-before-completion` before claiming success.

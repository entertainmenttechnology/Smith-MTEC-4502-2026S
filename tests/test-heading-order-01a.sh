#!/bin/bash
# Test script to check heading order in 01a_Reflective_essay_draft_speculation_phase.md
# Ensures heading levels only increase by one (WCAG 2.1 heading-order rule)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
FILE="$REPO_ROOT/assignments/01a_Reflective_essay_draft_speculation_phase.md"

echo "Testing heading order in 01a_Reflective_essay_draft_speculation_phase.md"
echo "========================================================================"

if [ ! -f "$FILE" ]; then
    echo "❌ File not found: $FILE"
    exit 1
fi

# Extract all headings with their levels
python3 << PYTHON_SCRIPT
import re
import sys

with open("$FILE") as f:
    lines = f.readlines()

prev_level = 0
violations = []

for i, line in enumerate(lines, 1):
    match = re.match(r'^(#+)\s+(.+)$', line)
    if match:
        level = len(match.group(1))
        text = match.group(2).strip()
        
        # Check if heading level increases by more than 1
        if level > prev_level + 1:
            violations.append({
                'line': i,
                'prev_level': prev_level,
                'curr_level': level,
                'text': text
            })
        
        prev_level = level

if violations:
    print("\n❌ HEADING ORDER VIOLATIONS FOUND:\n")
    for v in violations:
        print(f"Line {v['line']}: Jumped from H{v['prev_level']} to H{v['curr_level']}")
        print(f"  Heading: {v['text'][:70]}")
        print()
    sys.exit(1)
else:
    print("\n✅ No heading order violations found")
    print("   All heading levels increase by exactly 1")
    sys.exit(0)
PYTHON_SCRIPT

exit_code=$?

echo "========================================================================"

if [ $exit_code -eq 0 ]; then
    echo "✅ Heading order test PASSED"
else
    echo "❌ Heading order test FAILED"
    echo ""
    echo "Fix: Ensure headings only increase by one level at a time"
    echo "Example: H1 → H2 → H3 (not H1 → H3)"
fi

exit $exit_code

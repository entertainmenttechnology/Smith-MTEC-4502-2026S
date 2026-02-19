#!/bin/bash
# Specific test for assignment 01a level-one heading
# This test ensures the accessibility issue reported in the GitHub issue does not regress
# Related issue: Page should contain a level-one heading on 01a assignment

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
FILE="$REPO_ROOT/assignments/01a_Reflective_essay_draft_speculation_phase.md"

echo "Testing accessibility: Level-one heading in 01a assignment"
echo "============================================================"
echo ""
echo "File: assignments/01a_Reflective_essay_draft_speculation_phase.md"
echo ""

# Check file exists
if [ ! -f "$FILE" ]; then
    echo "❌ FAIL: File does not exist"
    exit 1
fi

# Get first non-empty line
first_line=$(head -20 "$FILE" | grep -v '^[[:space:]]*$' | head -1)

# Check if it's a level-one heading (starts with "# " followed by content)
if [[ "$first_line" =~ ^#[[:space:]] ]]; then
    heading_text=$(echo "$first_line" | sed 's/^# //')
    echo "✅ PASS: File has level-one heading"
    echo "   Heading: $heading_text"
    echo ""
    echo "This ensures WCAG 2.1 compliance (2.4.1 Bypass Blocks)"
    echo "and passes axe-core 'page-has-heading-one' rule"
    exit 0
else
    echo "❌ FAIL: First non-empty line is not a level-one heading"
    echo "   Found: ${first_line:0:80}"
    echo "   Expected: Line starting with '# ' (level-one heading)"
    echo ""
    echo "Accessibility violation: page-has-heading-one"
    echo "See: https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one"
    exit 1
fi

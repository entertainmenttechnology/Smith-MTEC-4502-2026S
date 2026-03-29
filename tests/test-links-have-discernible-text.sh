#!/bin/bash
# Test that links in assignments/01a_Reflective_essay_draft_speculation_phase.md
# have discernible text (WCAG 2.1 link-name rule)
# See: https://dequeuniversity.com/rules/axe/4.11/link-name

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

FILE="$REPO_ROOT/assignments/01a_Reflective_essay_draft_speculation_phase.md"
REL_FILE="assignments/01a_Reflective_essay_draft_speculation_phase.md"

echo "Testing $REL_FILE for links with discernible text..."

if [ ! -f "$FILE" ]; then
    echo "❌ File not found: $REL_FILE"
    exit 1
fi

# Check for empty link text: [](...) pattern
if grep -qP '\[\]\([^)]*\)' "$FILE" 2>/dev/null; then
    echo "❌ $REL_FILE contains links without discernible text:"
    grep -nP '\[\]\([^)]*\)' "$FILE"
    echo ""
    echo "To fix: Add descriptive text between the brackets."
    echo "Example: [Link description](https://example.com)"
    exit 1
else
    echo "✅ $REL_FILE has no links with missing discernible text"
    echo "   All links (if any) have descriptive text — WCAG 2.1 link-name rule satisfied"
    exit 0
fi

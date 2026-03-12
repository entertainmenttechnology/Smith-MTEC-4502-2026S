#!/bin/bash
# Test script to check accessibility of assignments/01d_ Using Artificial Intelligence in your Analysis.md
# Validates:
#   1. The file has a level-one heading (WCAG 2.1, page-has-heading-one)
#   2. All markdown links have discernible (non-empty, descriptive) text (WCAG 2.4.4, link-name)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

FILE="$REPO_ROOT/assignments/01d_ Using Artificial Intelligence in your Analysis.md"
REL_FILE="assignments/01d_ Using Artificial Intelligence in your Analysis.md"

EXIT_CODE=0

echo "Testing accessibility of: $REL_FILE"
echo "=================================================="

# ── Test 1: Level-one heading ─────────────────────────────────────────────────
echo ""
echo "Test 1: Level-one heading (WCAG 2.1 – page-has-heading-one)"

if [ ! -f "$FILE" ]; then
    echo "❌ File not found: $REL_FILE"
    exit 1
fi

if head -n 30 "$FILE" | grep -q "^# "; then
    echo "✅ File has a level-one heading"
else
    echo "❌ File is missing a level-one heading"
    echo "   Expected: a line starting with '# ' near the top of the file"
    EXIT_CODE=1
fi

# ── Test 2: Links have discernible text ───────────────────────────────────────
echo ""
echo "Test 2: Markdown links have discernible text (WCAG 2.4.4 – link-name)"

EMPTY_LINK_COUNT=0

# Extract all markdown link texts using sed (portable POSIX) and check for empty/whitespace-only text
# Pattern: [text](url) — extract just the text portion
while IFS= read -r link_text; do
    if [[ -z "${link_text// /}" ]]; then
        echo "❌ Found a link with empty text in: $REL_FILE"
        EMPTY_LINK_COUNT=$((EMPTY_LINK_COUNT + 1))
        EXIT_CODE=1
    fi
done < <(sed -n 's/.*\[\([^]]*\)\]([^)]*).*/\1/p' "$FILE")

if [ "$EMPTY_LINK_COUNT" -eq 0 ]; then
    echo "✅ All markdown links have discernible text"
fi

# ── Summary ───────────────────────────────────────────────────────────────────
echo ""
echo "=================================================="

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All accessibility checks passed for $REL_FILE"
else
    echo "❌ Accessibility issues found in $REL_FILE"
    echo ""
    echo "To fix:"
    echo "  - Add a level-one heading (e.g. '# Title') as the first non-empty line"
    echo "  - Ensure every link has descriptive text: [descriptive text](url)"
fi

exit $EXIT_CODE

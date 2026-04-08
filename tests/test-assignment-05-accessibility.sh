#!/bin/bash
# Test script to check accessibility structure of assignments/05-Assignment_Evaluating_Portfolio_Platforms.md
# Ensures WCAG 2.1 compliance by validating:
#   - Proper level-one heading (page-has-heading-one rule)
#   - Standard heading syntax (single space after #)
#   - Heading hierarchy without skipped levels (region/structure rule)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
FILE="$REPO_ROOT/assignments/05-Assignment_Evaluating_Portfolio_Platforms.md"
REL_FILE="assignments/05-Assignment_Evaluating_Portfolio_Platforms.md"

EXIT_CODE=0

echo "Testing $REL_FILE for accessibility compliance..."
echo "=================================================="

# Check file exists
if [ ! -f "$FILE" ]; then
    echo "❌ File not found: $REL_FILE"
    exit 1
fi

# Test 1: Check for a level-one heading (WCAG 2.1 page-has-heading-one)
echo ""
echo "Test 1: Level-one heading (WCAG 2.1 page-has-heading-one)"
if head -n 10 "$FILE" | grep -q "^# "; then
    H1_LINE=$(head -n 10 "$FILE" | grep "^# " | head -1)
    echo "✅ Has H1 heading: $H1_LINE"
else
    echo "❌ Missing H1 heading in first 10 lines"
    echo "   Expected: Line starting with '# ' (single space)"
    EXIT_CODE=1
fi

# Test 2: Check standard heading syntax (no double-space after #)
echo ""
echo "Test 2: Standard heading syntax (no extra spaces after #)"
if grep -qE "^#{1,6}  " "$FILE"; then
    echo "❌ Found non-standard heading syntax (double space after #):"
    grep -nE "^#{1,6}  " "$FILE" | head -5
    EXIT_CODE=1
else
    echo "✅ All headings use standard syntax (single space after #)"
fi

# Test 3: Check heading hierarchy (no skipped levels)
echo ""
echo "Test 3: Heading hierarchy (no skipped levels)"
PREV_LEVEL=0
HIERARCHY_OK=1
while IFS= read -r line; do
    if [[ "$line" =~ ^(#{1,6})[[:space:]] ]]; then
        HASHES="${BASH_REMATCH[1]}"
        LEVEL=${#HASHES}
        if [ $PREV_LEVEL -gt 0 ] && [ $((LEVEL - PREV_LEVEL)) -gt 1 ]; then
            echo "❌ Heading level skipped: went from H$PREV_LEVEL to H$LEVEL"
            echo "   Line: $line"
            HIERARCHY_OK=0
            EXIT_CODE=1
        fi
        PREV_LEVEL=$LEVEL
    fi
done < "$FILE"
if [ $HIERARCHY_OK -eq 1 ]; then
    echo "✅ Heading hierarchy is valid (no skipped levels)"
fi

echo ""
echo "=================================================="
if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ $REL_FILE passes all accessibility checks"
else
    echo "❌ $REL_FILE has accessibility issues that need to be fixed"
fi

exit $EXIT_CODE

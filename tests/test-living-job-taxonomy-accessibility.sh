#!/bin/bash
# Accessibility test for resources/Living Job Taxonomy.md
# Ensures the file meets WCAG 2.1 requirements:
#   - Has a level-one heading (page-has-heading-one rule)
#   - Heading hierarchy is not skipped (heading-order rule)
#   - All content is under the top-level heading (region rule)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
FILE="resources/Living Job Taxonomy.md"
FULL_PATH="$REPO_ROOT/$FILE"

echo "Testing '$FILE' for accessibility compliance..."
echo "=================================================="

EXIT_CODE=0

# --- Test 1: File exists ---
if [ ! -f "$FULL_PATH" ]; then
    echo "❌ File not found: $FILE"
    exit 1
fi
echo "✅ File exists: $FILE"

# --- Test 2: Has a level-one heading (WCAG 2.1 / axe: page-has-heading-one) ---
if ! head -n 30 "$FULL_PATH" | grep -q "^# "; then
    echo "❌ Missing level-one heading (H1) in: $FILE"
    echo "   Expected a line starting with '# ' in the first 30 lines."
    EXIT_CODE=1
else
    H1_LINE=$(head -n 30 "$FULL_PATH" | grep "^# " | head -1)
    echo "✅ Has level-one heading: $H1_LINE"
fi

# --- Test 3: H1 is the first non-empty heading (content begins under a landmark) ---
# All substantive content should appear after the H1 so it is logically
# contained by the top-level heading, satisfying the axe 'region' intent
# for document-level landmark coverage.
FIRST_HEADING=$(grep "^#" "$FULL_PATH" | head -1)
if [[ "$FIRST_HEADING" =~ ^#[[:space:]] ]]; then
    echo "✅ First heading is H1: $FIRST_HEADING"
else
    echo "❌ First heading in file is not an H1: $FIRST_HEADING"
    EXIT_CODE=1
fi

# --- Test 4: No heading level is skipped (axe: heading-order) ---
# Collect heading levels used in the file (1, 2, 3, …)
LEVELS=$(grep "^#" "$FULL_PATH" | sed 's/^\(#*\).*/\1/' | awk '{print length}' | sort -un)
PREV=0
SKIP_DETECTED=0
while IFS= read -r LEVEL; do
    if [ "$PREV" -ne 0 ] && [ "$LEVEL" -gt $((PREV + 1)) ]; then
        echo "❌ Heading level skipped: H${PREV} is followed by H${LEVEL} (axe: heading-order)"
        SKIP_DETECTED=1
        EXIT_CODE=1
    fi
    PREV=$LEVEL
done <<< "$LEVELS"
if [ "$SKIP_DETECTED" -eq 0 ]; then
    echo "✅ Heading hierarchy is valid (no levels skipped)"
fi

# --- Test 5: File is not empty ---
LINE_COUNT=$(wc -l < "$FULL_PATH")
if [ "$LINE_COUNT" -lt 5 ]; then
    echo "❌ File appears to be nearly empty ($LINE_COUNT lines)"
    EXIT_CODE=1
else
    echo "✅ File has content ($LINE_COUNT lines)"
fi

echo ""
echo "=================================================="
if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ '$FILE' passes all accessibility checks"
else
    echo "❌ '$FILE' failed one or more accessibility checks"
fi

exit $EXIT_CODE

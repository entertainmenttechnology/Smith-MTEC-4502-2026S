#!/bin/bash
# Test to verify landmark-one-main accessibility compliance for
# assignments/01c MTEC 4502 Assignment week 3  - Integrating Visualization.md
#
# The WCAG 2.1 landmark-one-main rule requires that a document has one main
# landmark. For GitHub-rendered markdown, a proper level-one heading (H1)
# establishes the document's primary content structure and serves as the
# semantic entry point for the page's main content region.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

FILE="assignments/01c MTEC 4502 Assignment week 3  - Integrating Visualization.md"
FULL_PATH="$REPO_ROOT/$FILE"

echo "Testing landmark-one-main accessibility for:"
echo "  $FILE"
echo ""

EXIT_CODE=0

# Check 1: File exists
if [ ! -f "$FULL_PATH" ]; then
    echo "❌ File not found: $FILE"
    exit 1
fi
echo "✅ File exists"

# Check 2: File has a level-one heading (H1)
# A level-one heading is required for WCAG 2.1 compliance and serves
# as the semantic anchor for the document's main content region.
if head -n 30 "$FULL_PATH" | grep -q "^# "; then
    H1=$(head -n 30 "$FULL_PATH" | grep "^# " | head -1)
    echo "✅ Has level-one heading (H1): $H1"
else
    echo "❌ Missing level-one heading (H1)"
    echo "   A level-one heading is required for landmark-one-main compliance."
    echo "   Add a heading like: # Page Title"
    EXIT_CODE=1
fi

# Check 3: H1 appears near the top of the document (within first 5 non-empty lines)
# This ensures the main landmark is immediately identifiable
NON_EMPTY_LINES=$(grep -v '^[[:space:]]*$' "$FULL_PATH" | head -5)
if echo "$NON_EMPTY_LINES" | grep -q "^# "; then
    echo "✅ Level-one heading appears near the top of the document"
else
    echo "❌ Level-one heading is not near the top of the document"
    echo "   The H1 heading should be one of the first non-empty lines."
    EXIT_CODE=1
fi

# Check 4: Document has proper heading hierarchy (H2 sections present)
# Proper heading hierarchy supports landmark navigation for screen readers
if grep -q "^## " "$FULL_PATH"; then
    H2_COUNT=$(grep -c "^## " "$FULL_PATH")
    echo "✅ Has $H2_COUNT H2 section heading(s) for content structure"
else
    echo "⚠️  No H2 headings found — consider adding section headings for structure"
fi

echo ""
echo "=================================================="
if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ $FILE passes landmark-one-main accessibility check"
else
    echo "❌ $FILE failed landmark-one-main accessibility check"
fi

exit $EXIT_CODE

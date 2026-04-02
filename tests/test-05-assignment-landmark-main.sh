#!/bin/bash
# Specific test for assignments/05-Assignment_Evaluating_Portfolio_Platforms.md
# Ensures the file meets landmark-one-main accessibility requirements:
#   - Exactly one H1 heading (maps to the <main> content landmark when rendered)
#   - No inline <main> HTML elements (would conflict with the rendered page template)
# This prevents regression of the axe landmark-one-main violation.

set -e

FILE="assignments/05-Assignment_Evaluating_Portfolio_Platforms.md"
EXIT_CODE=0

echo "Testing $FILE for landmark-main accessibility compliance..."
echo "============================================================"

if [ ! -f "$FILE" ]; then
    echo "❌ File not found: $FILE"
    exit 1
fi

# Check for exactly one H1 heading
H1_COUNT=$(grep -c "^# " "$FILE" || true)

if [ "$H1_COUNT" -eq 1 ]; then
    H1_LINE=$(grep "^# " "$FILE")
    echo "✅ Exactly one H1 heading found (main landmark): $H1_LINE"
elif [ "$H1_COUNT" -eq 0 ]; then
    echo "❌ No H1 heading found — document lacks a main landmark"
    echo "   Fix: Add a single '# Title' heading near the top of the file"
    EXIT_CODE=1
else
    echo "❌ Multiple H1 headings found ($H1_COUNT) — ambiguous main landmark"
    echo "   Fix: Ensure only one '# Heading' exists in the file"
    EXIT_CODE=1
fi

# Check for conflicting <main> HTML elements
MAIN_TAG_COUNT=$(grep -c -i "<main" "$FILE" || true)

if [ "$MAIN_TAG_COUNT" -eq 0 ]; then
    echo "✅ No conflicting <main> HTML elements found"
else
    echo "❌ Found $MAIN_TAG_COUNT inline <main> HTML element(s) — conflicts with rendered page template"
    echo "   Fix: Remove <main> HTML tags from the markdown content"
    EXIT_CODE=1
fi

echo ""
if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ $FILE meets landmark-main accessibility requirements"
else
    echo "❌ $FILE has landmark-main accessibility issues (see above)"
fi

exit $EXIT_CODE

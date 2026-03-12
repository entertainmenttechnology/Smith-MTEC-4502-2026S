#!/bin/bash
# Test script to check markdown files for landmark-one-main accessibility compliance
# Verifies that assignment files have proper document structure and do not contain
# inline HTML elements that would conflict with the page's main landmark.
# This ensures WCAG 2.1 compliance with the landmark-one-main rule.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

TARGET_FILE="assignments/01c2-mtec_4502_assignment_1c_part2_future_modeling_and_adaptive_planning.md"

echo "Checking $TARGET_FILE for landmark-one-main accessibility compliance..."
echo "=================================================================="

EXIT_CODE=0

# Check 1: File exists
if [ ! -f "$TARGET_FILE" ]; then
    echo "❌ File not found: $TARGET_FILE"
    exit 1
fi

echo "✅ File exists: $TARGET_FILE"

# Check 2: File has a level-one heading (H1) for proper document structure
if head -n 30 "$TARGET_FILE" | grep -q "^# "; then
    echo "✅ File has a level-one heading"
else
    echo "❌ File is missing a level-one heading"
    EXIT_CODE=1
fi

# Check 3: File does not contain duplicate/conflicting <main> elements.
# Adding <main> in markdown content would create nested main elements when
# rendered inside GitHub's page layout, which already provides a <main> landmark.
if grep -qi "<main" "$TARGET_FILE"; then
    echo "❌ File contains a <main> HTML element which would create duplicate landmarks"
    EXIT_CODE=1
else
    echo "✅ File does not contain conflicting <main> HTML elements"
fi

# Check 4: File does not contain structural HTML elements that could break page layout
PROBLEMATIC=("<html" "</html>" "<head>" "</head>" "<body" "</body>")
FOUND_STRUCTURAL=0
for element in "${PROBLEMATIC[@]}"; do
    if grep -qi "$element" "$TARGET_FILE"; then
        echo "❌ File contains structural HTML element: $element"
        FOUND_STRUCTURAL=1
        EXIT_CODE=1
    fi
done
if [ $FOUND_STRUCTURAL -eq 0 ]; then
    echo "✅ File does not contain structural HTML elements that could break page layout"
fi

echo ""
echo "=================================================================="
if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ $TARGET_FILE passes landmark-one-main accessibility checks"
else
    echo "❌ $TARGET_FILE has issues that may affect landmark-one-main accessibility"
    echo ""
    echo "To fix:"
    echo "  - Ensure the file has a level-one heading (# Title)"
    echo "  - Remove any <main> HTML elements from the markdown content"
    echo "  - Remove any structural HTML elements (<body>, <html>, <head>)"
fi

exit $EXIT_CODE

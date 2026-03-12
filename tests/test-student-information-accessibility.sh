#!/bin/bash
# Test script to verify student-information.md has proper semantic structure
# for WCAG 2.1 compliance with the axe 'region' rule:
# "All page content should be contained by landmarks"
#
# When rendered as HTML, all markdown content is placed inside GitHub's <main>
# landmark. This test verifies the file has no raw HTML block elements that
# could render outside of landmark regions.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

FILE="$REPO_ROOT/student-information.md"

echo "Testing student-information.md for landmark-compatible accessibility structure..."
echo "================================================================================"
echo ""

EXIT_CODE=0

# Check 1: File exists
echo "Check 1: File exists..."
if [ ! -f "$FILE" ]; then
    echo "❌ File not found: $FILE"
    exit 1
fi
echo "✅ File found: $FILE"

# Check 2: File has a level-one heading (H1)
# A page-level H1 heading is required for proper landmark region identification
echo ""
echo "Check 2: Level-one heading (H1) present..."
h1_line=$(grep -n "^# " "$FILE" | head -1)
if [ -n "$h1_line" ]; then
    echo "✅ H1 heading found: $h1_line"
else
    echo "❌ No H1 heading found - required so content renders inside landmark regions"
    EXIT_CODE=1
fi

# Check 3: H1 appears before any other headings (proper heading hierarchy)
echo ""
echo "Check 3: Proper heading hierarchy (H1 before H2/H3)..."
h1_linenum=$(grep -n "^# " "$FILE" | head -1 | cut -d: -f1)
h2_linenum=$(grep -n "^## " "$FILE" | head -1 | cut -d: -f1)
h3_linenum=$(grep -n "^### " "$FILE" | head -1 | cut -d: -f1)

if [ -z "$h1_linenum" ]; then
    echo "❌ No H1 heading - hierarchy check skipped"
    EXIT_CODE=1
elif [ -n "$h2_linenum" ] && [ "$h2_linenum" -lt "$h1_linenum" ]; then
    echo "❌ H2 (line $h2_linenum) appears before H1 (line $h1_linenum) - invalid hierarchy"
    EXIT_CODE=1
elif [ -n "$h3_linenum" ] && [ "$h3_linenum" -lt "$h1_linenum" ]; then
    echo "❌ H3 (line $h3_linenum) appears before H1 (line $h1_linenum) - invalid hierarchy"
    EXIT_CODE=1
else
    echo "✅ Heading hierarchy is valid (H1 at line $h1_linenum)"
fi

# Check 4: No raw HTML block elements that could render outside landmark regions
# Raw block-level HTML elements (e.g., <div>, <p>) that appear as the first
# element on a line could render outside of the markdown landmark context.
echo ""
echo "Check 4: No raw HTML block elements that could render outside landmarks..."
raw_html=$(grep -nE "^<(div|p|ul|ol|li|dl|dt|dd|table|h[1-6]|blockquote|pre|figure|figcaption|address|details|summary|hr)(\s|>|/)" "$FILE" 2>/dev/null || true)
if [ -n "$raw_html" ]; then
    echo "❌ Raw HTML block elements found that may render outside landmark regions:"
    echo "$raw_html" | while IFS= read -r line; do
        echo "   $line"
    done
    EXIT_CODE=1
else
    echo "✅ No raw HTML block elements found outside landmark containers"
fi

# Check 5: File has meaningful content (not just headings)
echo ""
echo "Check 5: File has content inside landmark sections..."
content_lines=$(grep -v "^#\|^[[:space:]]*$\|^---" "$FILE" | wc -l)
if [ "$content_lines" -gt 0 ]; then
    echo "✅ File has $content_lines lines of content inside heading sections"
else
    echo "❌ File has no content inside sections - landmark regions would be empty"
    EXIT_CODE=1
fi

echo ""
echo "================================================================================"
if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ student-information.md passes landmark-compatible accessibility checks"
    echo "   All content will be contained within landmark regions when rendered as HTML"
else
    echo "❌ student-information.md has accessibility structure issues"
    echo ""
    echo "To fix:"
    echo "  - Ensure the file starts with a level-one heading (# Title)"
    echo "  - Avoid raw HTML block elements at the start of lines"
    echo "  - Ensure headings follow a proper hierarchy (H1 > H2 > H3)"
fi

exit $EXIT_CODE

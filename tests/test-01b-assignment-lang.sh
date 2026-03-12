#!/bin/bash
# Test script to verify that assignments/01b MTEC 4502 Strategic Framework Assignment.md
# meets WCAG 2.1 accessibility requirements:
#   - page-has-heading-one: document contains a level-one heading
#
# Note: The html-has-lang rule (requiring <html lang="en">) is enforced by
# GitHub's page template for rendered Markdown, not by the Markdown content itself.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

FILE="assignments/01b MTEC 4502 Strategic Framework Assignment.md"
FULL_PATH="$REPO_ROOT/$FILE"

EXIT_CODE=0

echo "Accessibility checks for: $FILE"
echo "=================================================="

# Check file exists
if [ ! -f "$FULL_PATH" ]; then
    echo "❌ File not found: $FILE"
    exit 1
fi

# Check: Level-one heading (WCAG 2.1 page-has-heading-one)
first_h1=$(head -n 5 "$FULL_PATH" | grep "^# " | head -1)
if [ -n "$first_h1" ]; then
    echo "✅ Has level-one heading (page-has-heading-one): $first_h1"
else
    echo "❌ Missing level-one heading"
    echo "   Expected: A line starting with '# ' in the first 5 lines"
    echo "   This is required for WCAG 2.1 compliance (page-has-heading-one rule)."
    EXIT_CODE=1
fi

echo ""
echo "=================================================="
if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All accessibility checks passed for $FILE"
else
    echo "❌ Some accessibility checks failed for $FILE"
    echo ""
    echo "To fix: Add a level-one heading (e.g., '# Title') as the first line."
fi

exit $EXIT_CODE

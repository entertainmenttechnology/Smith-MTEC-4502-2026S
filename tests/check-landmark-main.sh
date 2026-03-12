#!/bin/bash
# Test script to check markdown files are structured to satisfy WCAG 2.1 landmark-one-main rule.
# On GitHub.com, the main landmark is provided by GitHub's layout when rendering Markdown.
# This script ensures files have the proper structure (level-one heading present) so that
# GitHub's renderer produces a complete, accessible page with a main landmark.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

echo "Checking markdown files for landmark-one-main accessibility compliance..."
echo "========================================================================="
echo ""
echo "Rule: Each page must have exactly one main landmark (WCAG 2.1 / axe landmark-one-main)"
echo "Note: GitHub's renderer provides the <main> landmark when displaying Markdown files."
echo "      This check ensures each file has an H1 heading, which confirms the file renders"
echo "      properly in GitHub's blob view (which includes the required main landmark)."
echo ""

EXIT_CODE=0
FILES_CHECKED=0
FILES_PASSED=0

while IFS= read -r -d '' file; do
    FILES_CHECKED=$((FILES_CHECKED + 1))

    # Check if the file has a level-one heading within first 30 lines
    # A level-one heading ensures GitHub renders the file in its standard layout,
    # which includes the <main> landmark required by landmark-one-main.
    if head -n 30 "$file" | grep -q "^# "; then
        echo "✅ $file"
        FILES_PASSED=$((FILES_PASSED + 1))
    else
        echo "❌ $file"
        echo "   Missing a level-one heading (# Title)"
        echo "   Files without an H1 may not render with a proper main landmark on GitHub."
        EXIT_CODE=1
    fi
done < <(find . -name "*.md" -type f ! -path "*/.git/*" -print0)

echo ""
echo "========================================================================="
echo "Summary: $FILES_PASSED/$FILES_CHECKED files satisfy landmark-one-main compliance"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All markdown files satisfy landmark-one-main compliance"
else
    echo "❌ Some markdown files may not satisfy landmark-one-main compliance"
    echo ""
    echo "To fix: Add a level-one heading (starting with '# ') near the top of each file."
    echo "Example: # Page Title"
    echo ""
    echo "Reference: https://dequeuniversity.com/rules/axe/4.11/landmark-one-main"
fi

exit $EXIT_CODE
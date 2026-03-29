#!/bin/bash
# Script to check that all markdown links have discernible text
# This helps prevent accessibility issues where links lack descriptive text
# (WCAG 2.1 Success Criterion 2.4.4: Link Purpose)
# See: https://dequeuniversity.com/rules/axe/4.11/link-name

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "Checking markdown files for links with discernible text..."
echo "=========================================================="

EXIT_CODE=0
CHECKED=0
FILES_WITH_ISSUES=0

# Find all markdown files (excluding .git directory and node_modules)
while IFS= read -r -d '' file; do
    CHECKED=$((CHECKED + 1))
    REL_PATH="${file#$REPO_ROOT/}"
    FILE_HAS_ISSUES=0

    # Check for empty link text: [](...) or [ ](...)
    # Pattern matches markdown links with empty or whitespace-only text (anywhere in line)
    if grep -nP '\[[ \t]*\]\s*\(' "$file" 2>/dev/null | grep -q .; then
        while IFS= read -r match; do
            echo "❌ Empty link text in $REL_PATH: $match"
            FILE_HAS_ISSUES=1
            EXIT_CODE=1
        done < <(grep -nP '\[[ \t]*\]\s*\(' "$file" 2>/dev/null)
    fi

    if [ $FILE_HAS_ISSUES -eq 0 ]; then
        echo "✅ Links OK: $REL_PATH"
    else
        FILES_WITH_ISSUES=$((FILES_WITH_ISSUES + 1))
    fi
done < <(find "$REPO_ROOT" -name "*.md" -type f ! -path "*/\.git/*" ! -path "*/node_modules/*" -print0)

echo ""
echo "=========================================================="
echo "Results: Checked $CHECKED files, $FILES_WITH_ISSUES file(s) with link issues"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All markdown links have discernible text!"
else
    echo "❌ Some markdown links are missing discernible text."
    echo ""
    echo "To fix: Ensure all markdown links have descriptive text between [ and ]."
    echo "Example: [Visit our homepage](https://example.com)"
    echo "Instead of: [](https://example.com)"
    echo ""
    echo "This is required for WCAG 2.1 accessibility compliance (link-name rule)."
fi

exit $EXIT_CODE

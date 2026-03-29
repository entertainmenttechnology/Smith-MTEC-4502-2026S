#!/bin/bash
# Script to check that all markdown links have discernible text
# This helps prevent accessibility issues where links lack readable text (WCAG 2.1 link-name rule)
# See: https://dequeuniversity.com/rules/axe/4.11/link-name

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "Checking markdown files for links with discernible text..."
echo "==========================================================="

EXIT_CODE=0
CHECKED=0
MISSING=0

# Find all markdown files (excluding .git directory and node_modules)
while IFS= read -r -d '' file; do
    CHECKED=$((CHECKED + 1))
    REL_PATH="${file#$REPO_ROOT/}"

    # Check for empty link text: [](...) pattern
    # This regex matches [ followed immediately by ] (empty brackets)
    EMPTY_LINKS=$(grep -nP '\[\]\([^)]*\)' "$file" 2>/dev/null || true)
    if [ -n "$EMPTY_LINKS" ]; then
        echo "❌ Links without discernible text found in: $REL_PATH"
        echo "$EMPTY_LINKS" | while IFS= read -r line; do
            echo "   $line"
        done
        MISSING=$((MISSING + 1))
        EXIT_CODE=1
    else
        echo "✅ All links have discernible text: $REL_PATH"
    fi
done < <(find "$REPO_ROOT" -name "*.md" -type f ! -path "*/\.git/*" ! -path "*/node_modules/*" -print0)

echo ""
echo "==========================================================="
echo "Results: Checked $CHECKED files, $MISSING files have links without discernible text"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All links in markdown files have discernible text!"
else
    echo "❌ Some markdown files contain links without discernible text."
    echo ""
    echo "To fix: Ensure all links have descriptive text between the brackets."
    echo "Example: [Link description](https://example.com)"
    echo "Instead of: [](https://example.com)"
    echo ""
    echo "This is required for WCAG 2.1 accessibility compliance (link-name rule)."
    echo "See: https://dequeuniversity.com/rules/axe/4.11/link-name"
fi

exit $EXIT_CODE

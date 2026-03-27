#!/bin/bash
# Script to check that all markdown links have discernible text
# This helps prevent accessibility issues where links lack accessible names
# WCAG 2.1 Success Criterion 4.1.2 / axe rule: link-name

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "Checking markdown files for links with discernible text..."
echo "==========================================================="

EXIT_CODE=0
CHECKED=0
VIOLATIONS=0

# Find all markdown files (excluding .git directory and node_modules)
while IFS= read -r -d '' file; do
    CHECKED=$((CHECKED + 1))
    REL_PATH="${file#$REPO_ROOT/}"
    FILE_VIOLATIONS=0

    # Find links with empty text: [](...) — the link text between [ ] is empty or whitespace only
    while IFS= read -r match; do
        echo "❌ Empty link text in: $REL_PATH"
        echo "   Found: $match"
        FILE_VIOLATIONS=$((FILE_VIOLATIONS + 1))
        VIOLATIONS=$((VIOLATIONS + 1))
        EXIT_CODE=1
    done < <(grep -oP '\[\s*\]\([^)]+\)' "$file" 2>/dev/null || true)

    if [ "$FILE_VIOLATIONS" -eq 0 ]; then
        echo "✅ All links have text: $REL_PATH"
    fi
done < <(find "$REPO_ROOT" -name "*.md" -type f ! -path "*/\.git/*" ! -path "*/node_modules/*" -print0)

echo ""
echo "==========================================================="
echo "Results: Checked $CHECKED files, $VIOLATIONS links with empty text"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All markdown links have discernible text!"
else
    echo "❌ Some markdown links are missing discernible text."
    echo ""
    echo "To fix: Ensure every link has non-empty text between the brackets."
    echo "Example: [Link Title](https://example.com)"
    echo ""
    echo "This is required for WCAG 2.1 accessibility compliance (link-name rule)."
    echo "See: https://dequeuniversity.com/rules/axe/4.11/link-name"
fi

exit $EXIT_CODE

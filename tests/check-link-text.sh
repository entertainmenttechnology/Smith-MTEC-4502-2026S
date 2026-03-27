#!/bin/bash
# Test script to check markdown files have links with discernible text for accessibility compliance
# This ensures WCAG 2.1 compliance by validating that all links have accessible names
# axe rule: link-name — https://dequeuniversity.com/rules/axe/4.11/link-name

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

echo "Checking markdown files for links with discernible text..."
echo "==========================================================="
echo ""

EXIT_CODE=0
FILES_CHECKED=0
VIOLATIONS=0

while IFS= read -r -d '' file; do
    # Skip hidden directories (like .git)
    if [[ "$file" == *"/.git/"* ]]; then
        continue
    fi

    FILES_CHECKED=$((FILES_CHECKED + 1))
    FILE_VIOLATIONS=0

    # Find links with empty text: [](...) — the link text between [ ] is empty or whitespace only
    while IFS= read -r match; do
        echo "❌ $file"
        echo "   Empty link text found: $match"
        echo "   Expected: Links must have non-empty text, e.g. [Link Title](url)"
        FILE_VIOLATIONS=$((FILE_VIOLATIONS + 1))
        VIOLATIONS=$((VIOLATIONS + 1))
        EXIT_CODE=1
    done < <(grep -oP '\[\s*\]\([^)]+\)' "$file" 2>/dev/null || true)

    if [ "$FILE_VIOLATIONS" -eq 0 ]; then
        echo "✅ $file"
    fi
done < <(find . -name "*.md" -type f -print0 | grep -zv ".git")

echo ""
echo "==========================================================="
echo "Summary: $FILES_CHECKED files checked, $VIOLATIONS empty-text links found"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All markdown links have discernible text"
else
    echo "❌ Some markdown links are missing discernible text"
    echo ""
    echo "To fix: Add descriptive text between the brackets of each link."
    echo "Example: [Link Title](https://example.com)"
fi

exit $EXIT_CODE

#!/bin/bash
# Test script to check markdown files have links with discernible text for accessibility compliance
# This ensures WCAG 2.1 compliance by validating that all markdown links have non-empty link text
# (axe rule: link-name, WCAG 2.1 Success Criterion 2.4.4)

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
    FILE_HAD_VIOLATION=0

    # Check for markdown links with empty or whitespace-only link text: [](url) or [ ](url)
    while IFS= read -r line_info; do
        LINE_NUM=$(echo "$line_info" | cut -d: -f1)
        LINE_CONTENT=$(echo "$line_info" | cut -d: -f2-)
        echo "❌ $file (line $LINE_NUM): empty link text found"
        echo "   Line: $LINE_CONTENT"
        echo "   Expected: Link text between brackets, e.g. [descriptive text](url)"
        FILE_HAD_VIOLATION=1
        VIOLATIONS=$((VIOLATIONS + 1))
        EXIT_CODE=1
    done < <(grep -n -E '\[\s*\]\(' "$file" 2>/dev/null || true)

    if [ "$FILE_HAD_VIOLATION" -eq 0 ]; then
        echo "✅ $file"
    fi
done < <(find . -name "*.md" -type f -print0 | grep -zv ".git")

echo ""
echo "==========================================================="
echo "Summary: Checked $FILES_CHECKED files, found $VIOLATIONS link(s) with empty text"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All markdown links have discernible text"
else
    echo "❌ Some markdown links are missing discernible text"
    echo ""
    echo "To fix: Replace empty link text [] with descriptive text"
    echo "Example: [MIT Work of the Future](https://workofthefuture-taskforce.mit.edu/)"
fi

exit $EXIT_CODE

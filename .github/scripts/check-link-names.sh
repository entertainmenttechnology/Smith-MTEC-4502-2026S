#!/bin/bash
# Script to check that all markdown links have discernible text
# This helps prevent accessibility violations where links lack accessible names
# (WCAG 2.1 Success Criterion 2.4.4, axe rule: link-name)

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

    # Check for markdown links with empty or whitespace-only link text: [](url) or [ ](url)
    while IFS= read -r line_info; do
        LINE_NUM=$(echo "$line_info" | cut -d: -f1)
        LINE_CONTENT=$(echo "$line_info" | cut -d: -f2-)
        echo "❌ Empty link text in $REL_PATH (line $LINE_NUM): $LINE_CONTENT"
        FILE_VIOLATIONS=$((FILE_VIOLATIONS + 1))
        VIOLATIONS=$((VIOLATIONS + 1))
        EXIT_CODE=1
    done < <(grep -n -E '\[\s*\]\(' "$file" 2>/dev/null || true)

done < <(find "$REPO_ROOT" -name "*.md" -type f ! -path "*/\.git/*" ! -path "*/node_modules/*" -print0)

echo ""
echo "==========================================================="
echo "Results: Checked $CHECKED files, found $VIOLATIONS link(s) with empty text"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All markdown links have discernible text!"
else
    echo "❌ Some markdown links are missing discernible text."
    echo ""
    echo "To fix: Ensure every link has descriptive text between the brackets."
    echo "Example: [Visit our homepage](https://example.com)"
    echo "Instead of: [](https://example.com)"
    echo ""
    echo "This is required for WCAG 2.1 Success Criterion 2.4.4 (Link Purpose)"
    echo "and the axe 'link-name' accessibility rule."
fi

exit $EXIT_CODE

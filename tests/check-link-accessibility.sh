#!/bin/bash
# Test script to check markdown files have no links with empty or whitespace-only text
# This ensures WCAG 2.1 compliance by validating that all links have discernible text
# (axe rule: link-name - https://dequeuniversity.com/rules/axe/4.11/link-name)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

echo "Checking markdown files for links with discernible text..."
echo "==========================================================="
echo ""

EXIT_CODE=0
FILES_CHECKED=0
FILES_PASSED=0
VIOLATIONS_FOUND=0

while IFS= read -r -d '' file; do
    # Skip hidden directories (like .git)
    if [[ "$file" == *"/.git/"* ]]; then
        continue
    fi

    FILES_CHECKED=$((FILES_CHECKED + 1))
    FILE_VIOLATIONS=0

    # Check for empty link text: []( or ]( preceded by [ with only whitespace inside
    # Pattern: [](url) or [ ](url) - brackets with no or whitespace-only content
    while IFS= read -r line_info; do
        line_num="${line_info%%:*}"
        line_content="${line_info#*:}"
        echo "❌ $file (line $line_num): Link with empty or whitespace-only text found:"
        echo "   $line_content"
        FILE_VIOLATIONS=$((FILE_VIOLATIONS + 1))
        VIOLATIONS_FOUND=$((VIOLATIONS_FOUND + 1))
        EXIT_CODE=1
    done < <(grep -nP '\[\s*\]\([^)]*\)' "$file" 2>/dev/null || true)

    if [ "$FILE_VIOLATIONS" -eq 0 ]; then
        echo "✅ $file"
        FILES_PASSED=$((FILES_PASSED + 1))
    fi
done < <(find . -name "*.md" -type f -print0 | grep -zv ".git")

echo ""
echo "==========================================================="
echo "Summary: $FILES_PASSED/$FILES_CHECKED files have all links with discernible text"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All markdown links have discernible text"
else
    echo "❌ $VIOLATIONS_FOUND link(s) with empty or whitespace-only text found"
    echo ""
    echo "To fix: Ensure all markdown links have descriptive text between the brackets."
    echo "Example: [Visit the Job Listings page](https://example.com/jobs)"
    echo "Instead of: [](https://example.com/jobs) or [ ](https://example.com/jobs)"
fi

exit $EXIT_CODE

#!/bin/bash
# Test script to check markdown files have valid heading order (no skipped levels)
# This ensures WCAG 2.1 compliance by validating that heading levels only increase by one
# Reference: https://dequeuniversity.com/rules/axe/4.11/heading-order

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

echo "Checking markdown files for valid heading order..."
echo "=================================================="
echo ""

EXIT_CODE=0
FILES_CHECKED=0
FILES_PASSED=0

while IFS= read -r -d '' file; do
    # Skip hidden directories (like .git)
    if [[ "$file" == *"/.git/"* ]]; then
        continue
    fi

    FILES_CHECKED=$((FILES_CHECKED + 1))
    FILE_PASSED=1
    prev_level=0

    while IFS= read -r line; do
        if [[ "$line" =~ ^(#{1,6})[[:space:]] ]]; then
            level="${#BASH_REMATCH[1]}"

            # Heading levels should only increase by one at a time
            if [[ $prev_level -gt 0 && $level -gt $((prev_level + 1)) ]]; then
                if [[ $FILE_PASSED -eq 1 ]]; then
                    echo "❌ $file"
                    FILE_PASSED=0
                fi
                echo "   Heading order invalid: jumped from H${prev_level} to H${level}"
                echo "   Line: ${line:0:80}"
                EXIT_CODE=1
            fi

            prev_level=$level
        fi
    done < "$file"

    if [[ $FILE_PASSED -eq 1 ]]; then
        echo "✅ $file"
        FILES_PASSED=$((FILES_PASSED + 1))
    fi
done < <(find . -name "*.md" -type f -print0 | grep -zv ".git")

echo ""
echo "=================================================="
echo "Summary: $FILES_PASSED/$FILES_CHECKED files have valid heading order"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All markdown files have valid heading order"
else
    echo "❌ Some markdown files have invalid heading order"
    echo ""
    echo "To fix: Ensure headings only increase by one level at a time"
    echo "Example: An H2 section should use H3 (not H4) for its subsections"
fi

exit $EXIT_CODE

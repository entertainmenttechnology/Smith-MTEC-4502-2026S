#!/bin/bash
# Test script to check markdown files have valid heading order for accessibility compliance
# This ensures WCAG 2.1 compliance by validating that heading levels only increase by one
# (heading-order axe rule: https://dequeuniversity.com/rules/axe/4.11/heading-order)

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

check_heading_order() {
    local file="$1"
    local prev_level=0
    local line_num=0
    local file_ok=1

    while IFS= read -r line; do
        line_num=$((line_num + 1))
        # Match heading lines (up to 6 # signs followed by a space)
        if [[ "$line" =~ ^(#{1,6})[[:space:]] ]]; then
            local hashes="${BASH_REMATCH[1]}"
            local level=${#hashes}

            # Check if heading level increases by more than 1
            if [ "$prev_level" -gt 0 ] && [ "$level" -gt "$((prev_level + 1))" ]; then
                if [ "$file_ok" -eq 1 ]; then
                    echo "❌ $file"
                fi
                echo "   Line $line_num: heading jumps from H${prev_level} to H${level} (skips a level)"
                echo "   Content: ${line:0:80}"
                file_ok=0
                EXIT_CODE=1
            fi

            prev_level=$level
        fi
    done < "$file"

    if [ "$file_ok" -eq 1 ]; then
        echo "✅ $file"
        FILES_PASSED=$((FILES_PASSED + 1))
    fi
}

while IFS= read -r -d '' file; do
    # Skip hidden directories (like .git)
    if [[ "$file" == *"/.git/"* ]]; then
        continue
    fi

    FILES_CHECKED=$((FILES_CHECKED + 1))
    check_heading_order "$file"
done < <(find . -name "*.md" -type f -print0 | grep -zv ".git")

echo ""
echo "=================================================="
echo "Summary: $FILES_PASSED/$FILES_CHECKED files have valid heading order"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All markdown files have valid heading order"
else
    echo "❌ Some markdown files have invalid heading order"
    echo ""
    echo "To fix: Ensure heading levels only increase by one (e.g., H2 -> H3, not H2 -> H4)"
    echo "Reference: https://dequeuniversity.com/rules/axe/4.11/heading-order"
fi

exit $EXIT_CODE

#!/bin/bash
# Test script to check markdown files have valid heading order for accessibility compliance
# Ensures WCAG 2.1 compliance by validating heading levels only increase by one (heading-order rule)
# See: https://dequeuniversity.com/rules/axe/4.11/heading-order

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
    local violations=""

    while IFS= read -r line; do
        line_num=$((line_num + 1))
        # Match heading lines (# through ######)
        if [[ "$line" =~ ^(#{1,6})[[:space:]]+ ]]; then
            local hashes="${BASH_REMATCH[1]}"
            local level="${#hashes}"
            if [ "$prev_level" -gt 0 ] && [ "$level" -gt "$((prev_level + 1))" ]; then
                violations="$violations\n   Line $line_num: Heading jumps from h$prev_level to h$level (skips level)"
            fi
            prev_level="$level"
        fi
    done < "$file"

    echo "$violations"
}

while IFS= read -r -d '' file; do
    # Skip hidden directories (like .git)
    if [[ "$file" == *"/.git/"* ]]; then
        continue
    fi

    FILES_CHECKED=$((FILES_CHECKED + 1))

    violations=$(check_heading_order "$file")

    if [ -z "$violations" ]; then
        echo "✅ $file"
        FILES_PASSED=$((FILES_PASSED + 1))
    else
        echo "❌ $file"
        echo -e "$violations"
        EXIT_CODE=1
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
    echo "To fix: Ensure heading levels only increase by one at a time."
    echo "Example: # h1 -> ## h2 -> ### h3 (valid)"
    echo "Example: # h1 -> ### h3 (invalid, skips h2)"
fi

exit $EXIT_CODE

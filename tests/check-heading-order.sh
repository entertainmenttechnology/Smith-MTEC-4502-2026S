#!/bin/bash
# Test script to check markdown files have valid heading order for accessibility compliance
# This ensures WCAG 2.1 compliance by validating that heading levels only increase by one
# (axe rule: heading-order — https://dequeuniversity.com/rules/axe/4.11/heading-order)

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

    # Extract heading levels in order
    prev_level=0
    file_ok=1
    violation_line=""

    while IFS= read -r line; do
        # Match lines starting with one or more # followed by a space
        if [[ "$line" =~ ^(#{1,6})[[:space:]] ]]; then
            hashes="${BASH_REMATCH[1]}"
            level=${#hashes}
            jump=$((level - prev_level))
            if [ "$jump" -gt 1 ]; then
                file_ok=0
                violation_line="Jumped from h${prev_level} to h${level}: ${line:0:60}"
                break
            fi
            prev_level=$level
        fi
    done < "$file"

    if [ "$file_ok" -eq 1 ]; then
        echo "✅ $file"
        FILES_PASSED=$((FILES_PASSED + 1))
    else
        echo "❌ $file"
        echo "   $violation_line"
        echo "   Expected: heading levels should only increase by one"
        EXIT_CODE=1
    fi
done < <(find . -name "*.md" -type f -print0)

echo ""
echo "=================================================="
echo "Summary: $FILES_PASSED/$FILES_CHECKED files have valid heading order"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All markdown files have valid heading order"
else
    echo "❌ Some markdown files have heading order violations"
    echo ""
    echo "To fix: Ensure heading levels only increase by one (e.g., h1 → h2 → h3)"
    echo "Example: Do not jump from h1 directly to h3 without an h2 in between"
fi

exit $EXIT_CODE

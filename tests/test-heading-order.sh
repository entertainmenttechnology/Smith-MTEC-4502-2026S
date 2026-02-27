#!/bin/bash
# Test script to check markdown files have valid heading order for accessibility compliance
# Ensures heading levels only increase by one at a time (axe heading-order rule)
# This is required for WCAG 2.1 compliance

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
    FILE_PASS=1
    FILE_ISSUES=""

    prev_level=0
    line_num=0

    while IFS= read -r line; do
        line_num=$((line_num + 1))
        # Match heading lines (up to 6 # characters followed by a space)
        if [[ "$line" =~ ^(#{1,6})[[:space:]] ]]; then
            hashes="${BASH_REMATCH[1]}"
            level=${#hashes}
            if [[ $prev_level -gt 0 && $level -gt $((prev_level + 1)) ]]; then
                FILE_ISSUES="${FILE_ISSUES}\n   Line ${line_num}: Heading jumps from H${prev_level} to H${level}: ${line:0:60}"
                FILE_PASS=0
            fi
            prev_level=$level
        fi
    done < "$file"

    if [[ $FILE_PASS -eq 1 ]]; then
        echo "✅ $file"
        FILES_PASSED=$((FILES_PASSED + 1))
    else
        echo "❌ $file"
        echo -e "$FILE_ISSUES"
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
    echo "To fix: Ensure heading levels only increase by one at a time"
    echo "Example: H2 -> H3 is valid; H2 -> H4 is not"
fi

exit $EXIT_CODE

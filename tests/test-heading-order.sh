#!/bin/bash
# Test script to check heading order in markdown files for accessibility compliance
# Ensures heading levels only increase by one (WCAG 2.1 / axe heading-order rule)
# See: https://dequeuniversity.com/rules/axe/4.11/heading-order

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Files to check for valid heading order
FILES_TO_CHECK=(
    "assignments/01c MTEC 4502 Assignment week 3  - Integrating Visualization.md"
)

EXIT_CODE=0

check_heading_order() {
    local file="$1"
    local prev_level=0
    local line_num=0
    local errors=()

    while IFS= read -r line; do
        line_num=$((line_num + 1))
        # Match headings: #, ##, ###, ####, #####, ######
        if [[ "$line" =~ ^(#{1,6})[[:space:]] ]]; then
            hashes="${BASH_REMATCH[1]}"
            level=${#hashes}
            if [ "$prev_level" -gt 0 ] && [ "$level" -gt "$((prev_level + 1))" ]; then
                errors+=("Line $line_num: heading jumps from H$prev_level to H$level (skips a level)")
            fi
            prev_level=$level
        fi
    done < "$file"

    if [ ${#errors[@]} -eq 0 ]; then
        echo "✅ $file - heading order is valid"
        return 0
    else
        echo "❌ $file - heading order violations:"
        for err in "${errors[@]}"; do
            echo "   $err"
        done
        return 1
    fi
}

echo "Checking heading order in markdown files..."
echo "============================================"
echo ""

cd "$REPO_ROOT"

for file in "${FILES_TO_CHECK[@]}"; do
    if [ ! -f "$file" ]; then
        echo "❌ File not found: $file"
        EXIT_CODE=1
        continue
    fi
    check_heading_order "$file" || EXIT_CODE=1
done

echo ""
echo "============================================"
if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All checked files have valid heading order"
else
    echo "❌ Heading order violations found"
    echo ""
    echo "To fix: Ensure heading levels only increase by one at a time"
    echo "Example: H1 -> H2 -> H3 (valid), H1 -> H3 (invalid)"
fi

exit $EXIT_CODE

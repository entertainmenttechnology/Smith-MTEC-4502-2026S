#!/bin/bash
# Test script to check markdown files for proper heading order
# Ensures WCAG 2.1 compliance by validating that heading levels only increase by one
# This implements the axe "heading-order" rule: https://dequeuniversity.com/rules/axe/4.11/heading-order

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

echo "Checking markdown files for proper heading order..."
echo "=================================================="
echo ""

EXIT_CODE=0
FILES_CHECKED=0
FILES_PASSED=0

check_heading_order() {
    local file="$1"
    local prev_level=0
    local line_num=0
    local errors=()
    
    while IFS= read -r line; do
        line_num=$((line_num + 1))
        
        # Check if line is a heading (starts with #)
        if [[ "$line" =~ ^(#+)[[:space:]]+ ]]; then
            # Count the number of # characters
            local heading="${BASH_REMATCH[1]}"
            local curr_level=${#heading}
            
            # First heading can be any level (though typically should be 1)
            if [ $prev_level -eq 0 ]; then
                prev_level=$curr_level
                continue
            fi
            
            # Check if heading level increased by more than one
            if [ $curr_level -gt $((prev_level + 1)) ]; then
                errors+=("Line $line_num: Heading level jumped from h$prev_level to h$curr_level (should only increase by 1)")
                errors+=("  Content: ${line:0:80}")
            fi
            
            prev_level=$curr_level
        fi
    done < "$file"
    
    if [ ${#errors[@]} -eq 0 ]; then
        return 0
    else
        for error in "${errors[@]}"; do
            echo "   $error"
        done
        return 1
    fi
}

while IFS= read -r -d '' file; do
    # Skip hidden directories (like .git)
    if [[ "$file" == *"/.git/"* ]]; then
        continue
    fi
    
    FILES_CHECKED=$((FILES_CHECKED + 1))
    
    if check_heading_order "$file"; then
        echo "✅ $file"
        FILES_PASSED=$((FILES_PASSED + 1))
    else
        echo "❌ $file"
        EXIT_CODE=1
    fi
done < <(find . -name "*.md" -type f -print0)

echo ""
echo "=================================================="
echo "Summary: $FILES_PASSED/$FILES_CHECKED files have proper heading order"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All markdown files have proper heading order"
else
    echo "❌ Some markdown files have heading order violations"
    echo ""
    echo "To fix: Ensure heading levels only increase by one at a time"
    echo "Example: h1 -> h2 -> h3 (NOT h1 -> h3)"
fi

exit $EXIT_CODE

#!/bin/bash
# Test script to check markdown files have proper heading order for accessibility compliance
# This ensures WCAG 2.1 compliance by validating that heading levels only increase by one
# Reference: https://dequeuniversity.com/rules/axe/4.11/heading-order

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

# Function to check heading order in a single file
check_file_heading_order() {
    local file="$1"
    local prev_level=0
    local line_num=0
    local has_error=0
    
    while IFS= read -r line; do
        line_num=$((line_num + 1))
        
        # Check if line is a heading
        if [[ "$line" =~ ^(#{1,6})[[:space:]]+ ]]; then
            # Count the number of # characters
            heading="${BASH_REMATCH[1]}"
            current_level=${#heading}
            
            # If this is the first heading, it should be level 1
            if [ $prev_level -eq 0 ]; then
                if [ $current_level -ne 1 ]; then
                    echo "   ❌ Line $line_num: First heading should be level 1 (H1), found H$current_level"
                    echo "      ${line:0:80}"
                    has_error=1
                fi
            else
                # Heading level should not increase by more than 1
                level_jump=$((current_level - prev_level))
                if [ $level_jump -gt 1 ]; then
                    echo "   ❌ Line $line_num: Heading level jumps from H$prev_level to H$current_level (skip detected)"
                    echo "      ${line:0:80}"
                    has_error=1
                fi
            fi
            
            prev_level=$current_level
        fi
    done < "$file"
    
    return $has_error
}

while IFS= read -r -d '' file; do
    # Skip hidden directories (like .git)
    if [[ "$file" == *"/.git/"* ]]; then
        continue
    fi
    
    FILES_CHECKED=$((FILES_CHECKED + 1))
    
    echo "Checking $file..."
    if check_file_heading_order "$file"; then
        echo "✅ $file"
        FILES_PASSED=$((FILES_PASSED + 1))
    else
        EXIT_CODE=1
    fi
    echo ""
done < <(find . -name "*.md" -type f -print0 | grep -zv ".git")

echo "=================================================="
echo "Summary: $FILES_PASSED/$FILES_CHECKED files have proper heading order"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All markdown files have proper heading order"
else
    echo "❌ Some markdown files have heading order violations"
    echo ""
    echo "To fix:"
    echo "1. Ensure the first heading is level 1 (H1)"
    echo "2. Ensure heading levels only increase by one at a time"
    echo "   (e.g., H1 → H2 → H3, not H1 → H3)"
    echo "3. Heading levels can decrease by any amount (e.g., H3 → H1 is OK)"
fi

exit $EXIT_CODE

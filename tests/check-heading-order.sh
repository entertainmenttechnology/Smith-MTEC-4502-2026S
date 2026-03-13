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

# Function to check heading order in a file
check_heading_order() {
    local file="$1"
    local prev_level=0
    local line_num=0
    local error_found=0
    
    while IFS= read -r line; do
        line_num=$((line_num + 1))
        
        # Skip empty lines
        if [[ -z "$line" || "$line" =~ ^[[:space:]]*$ ]]; then
            continue
        fi
        
        # Check if line is a heading (starts with #)
        if [[ "$line" =~ ^(#{1,6})[[:space:]] ]]; then
            local level=${#BASH_REMATCH[1]}
            
            # First heading should be level 1
            if [[ $prev_level -eq 0 && $level -ne 1 ]]; then
                echo "   ❌ Line $line_num: First heading is level $level, should be level 1"
                echo "      ${line:0:80}"
                error_found=1
            # Subsequent headings should not skip levels
            elif [[ $prev_level -gt 0 && $level -gt $((prev_level + 1)) ]]; then
                echo "   ❌ Line $line_num: Heading level jumped from $prev_level to $level (should only increase by 1)"
                echo "      ${line:0:80}"
                error_found=1
            fi
            
            prev_level=$level
        fi
    done < "$file"
    
    return $error_found
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
        echo "❌ $file has heading order issues"
        EXIT_CODE=1
    fi
done < <(find . -name "*.md" -type f -print0 | grep -zv ".git")

echo ""
echo "=================================================="
echo "Summary: $FILES_PASSED/$FILES_CHECKED files have proper heading order"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All markdown files have proper heading order"
else
    echo "❌ Some markdown files have heading order issues"
    echo ""
    echo "To fix:"
    echo "  1. Ensure the first heading in the file is level 1 (# Heading)"
    echo "  2. Ensure heading levels only increase by one (e.g., # → ## → ### is valid, but # → ### is not)"
    echo "  3. Heading levels can decrease by any amount (e.g., ### → # is valid)"
fi

exit $EXIT_CODE

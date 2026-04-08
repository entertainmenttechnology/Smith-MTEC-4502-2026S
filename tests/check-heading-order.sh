#!/bin/bash
# Test script to check markdown files have proper heading order (levels only increase by one)
# This ensures WCAG 2.1 compliance by validating that heading levels don't skip (e.g., h1 -> h3)

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

while IFS= read -r -d '' file; do
    # Skip hidden directories (like .git)
    if [[ "$file" == *"/.git/"* ]]; then
        continue
    fi
    
    FILES_CHECKED=$((FILES_CHECKED + 1))
    
    # Extract heading levels from the file
    heading_levels=$(grep -n '^#' "$file" | sed 's/^\([0-9]*\):/#/' | sed 's/^\(#*\).*/\1/' | sed 's/#/1/g' | awk '{print length}')
    
    # Check if heading order is valid
    prev_level=0
    line_num=0
    order_valid=true
    error_message=""
    
    while IFS= read -r level; do
        if [ -n "$level" ]; then
            line_num=$((line_num + 1))
            
            # Check if level increases by more than one
            if [ "$prev_level" -gt 0 ] && [ "$level" -gt $((prev_level + 1)) ]; then
                order_valid=false
                error_message="Heading level jumps from h$prev_level to h$level"
                break
            fi
            
            prev_level=$level
        fi
    done <<< "$heading_levels"
    
    if [ "$order_valid" = true ]; then
        echo "✅ $file"
        FILES_PASSED=$((FILES_PASSED + 1))
    else
        echo "❌ $file"
        echo "   Error: $error_message"
        EXIT_CODE=1
    fi
done < <(find . -name "*.md" -type f -print0 | grep -zv ".git")

echo ""
echo "=================================================="
echo "Summary: $FILES_PASSED/$FILES_CHECKED files have proper heading order"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All markdown files have proper heading order"
else
    echo "❌ Some markdown files have invalid heading order"
    echo ""
    echo "To fix: Ensure heading levels only increase by one (h1 -> h2 -> h3, not h1 -> h3)"
    echo "Example: If you have h2, the next heading should be h2 or h3, not h4"
fi

exit $EXIT_CODE

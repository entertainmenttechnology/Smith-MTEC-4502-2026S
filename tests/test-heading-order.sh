#!/bin/bash
# Test script to check heading order in markdown files for accessibility compliance
# Ensures heading levels only increase by one (e.g., H1 -> H2, not H1 -> H3)
# This is required by WCAG 2.1 for proper document structure

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

echo "Checking markdown files for proper heading order..."
echo "===================================================="
echo ""

EXIT_CODE=0
FILES_CHECKED=0
FILES_PASSED=0
FILES_FAILED=0

# Function to check heading order in a single file
check_heading_order() {
    local file="$1"
    local prev_level=0
    local line_num=0
    local has_error=0
    local error_msg=""
    
    while IFS= read -r line; do
        line_num=$((line_num + 1))
        
        # Check if line is a heading
        if [[ "$line" =~ ^(#+)[[:space:]] ]]; then
            # Count the number of # characters
            heading="${BASH_REMATCH[1]}"
            current_level=${#heading}
            
            # Check if heading level skips (increases by more than 1)
            if [ $prev_level -gt 0 ] && [ $current_level -gt $((prev_level + 1)) ]; then
                error_msg="Line $line_num: Heading level jumps from H$prev_level to H$current_level (should only increase by 1)"
                has_error=1
                break
            fi
            
            prev_level=$current_level
        fi
    done < "$file"
    
    if [ $has_error -eq 1 ]; then
        echo "❌ $file"
        echo "   $error_msg"
        return 1
    else
        echo "✅ $file"
        return 0
    fi
}

# Find all markdown files (excluding .git directory)
while IFS= read -r -d '' file; do
    # Skip hidden directories (like .git)
    if [[ "$file" == *"/.git/"* ]]; then
        continue
    fi
    
    FILES_CHECKED=$((FILES_CHECKED + 1))
    
    if check_heading_order "$file"; then
        FILES_PASSED=$((FILES_PASSED + 1))
    else
        FILES_FAILED=$((FILES_FAILED + 1))
        EXIT_CODE=1
    fi
done < <(find . -name "*.md" -type f -print0 | grep -zv ".git")

echo ""
echo "===================================================="
echo "Summary: $FILES_PASSED/$FILES_CHECKED files have proper heading order"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All markdown files have proper heading order"
else
    echo "❌ Some markdown files have heading order issues"
    echo ""
    echo "Heading levels should only increase by one at a time."
    echo "Valid: H1 -> H2 -> H3"
    echo "Invalid: H1 -> H3 (skips H2)"
    echo ""
    echo "Learn more: https://dequeuniversity.com/rules/axe/4.11/heading-order"
fi

exit $EXIT_CODE

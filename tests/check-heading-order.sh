#!/bin/bash
# Test script to check markdown files have proper heading order for accessibility compliance
# This ensures WCAG 2.1 compliance by validating that heading levels only increase by one
# (e.g., h1 -> h2 -> h3, not h1 -> h3)
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

check_heading_order() {
    local file="$1"
    local prev_level=0
    local line_num=0
    local errors=()
    
    while IFS= read -r line; do
        line_num=$((line_num + 1))
        
        # Check if line is a heading (starts with #)
        if [[ "$line" =~ ^(#+)[[:space:]] ]]; then
            # Count the number of # characters
            local heading="${BASH_REMATCH[1]}"
            local current_level=${#heading}
            
            # Check if heading level increases by more than 1
            if [ $prev_level -gt 0 ] && [ $current_level -gt $((prev_level + 1)) ]; then
                errors+=("Line $line_num: Heading level jumps from h$prev_level to h$current_level")
                errors+=("  Content: ${line:0:80}")
            fi
            
            prev_level=$current_level
        fi
    done < "$file"
    
    if [ ${#errors[@]} -eq 0 ]; then
        return 0
    else
        for error in "${errors[@]}"; do
            echo "  $error"
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
done < <(find . -name "*.md" -type f -print0 | grep -zv ".git")

echo ""
echo "=================================================="
echo "Summary: $FILES_PASSED/$FILES_CHECKED files have proper heading order"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All markdown files have proper heading order"
else
    echo "❌ Some markdown files have improper heading order"
    echo ""
    echo "To fix: Ensure heading levels only increase by one at a time"
    echo "Good: # Title -> ## Section -> ### Subsection"
    echo "Bad:  # Title -> ### Subsection (skips h2)"
    echo ""
    echo "Reference: https://dequeuniversity.com/rules/axe/4.11/heading-order"
fi

exit $EXIT_CODE

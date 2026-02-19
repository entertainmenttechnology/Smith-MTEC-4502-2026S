#!/bin/bash
# Test script to check markdown files have proper heading order for accessibility compliance
# This ensures WCAG 2.1 compliance by validating heading levels only increase by one
# Implements axe rule: heading-order (https://dequeuniversity.com/rules/axe/4.11/heading-order)

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
    local violations=()
    local prev_level=0
    local line_num=0
    
    # Extract headings with line numbers
    while IFS= read -r line; do
        line_num=$((line_num + 1))
        
        # Match heading patterns (# through ######)
        if [[ "$line" =~ ^(#{1,6})[[:space:]] ]]; then
            local heading="${BASH_REMATCH[1]}"
            local current_level=${#heading}
            
            # First heading should be H1
            if [[ $prev_level -eq 0 && $current_level -ne 1 ]]; then
                violations+=("Line $line_num: First heading is H$current_level, should be H1")
            # Subsequent headings should not skip levels when increasing
            # Note: Decreasing by any amount is allowed (e.g., H4 to H2 is OK)
            elif [[ $prev_level -gt 0 && $current_level -gt $((prev_level + 1)) ]]; then
                violations+=("Line $line_num: Heading jumps from H$prev_level to H$current_level (skipping levels)")
            # Headings at same level or decreasing are valid (no action needed)
            fi
            
            prev_level=$current_level
        fi
    done < "$file"
    
    # Return violations
    if [[ ${#violations[@]} -gt 0 ]]; then
        printf '%s\n' "${violations[@]}"
        return 1
    else
        return 0
    fi
}

# Find all markdown files (excluding .git directory)
while IFS= read -r -d '' file; do
    FILES_CHECKED=$((FILES_CHECKED + 1))
    REL_PATH="${file#$REPO_ROOT/}"
    REL_PATH="${REL_PATH#./}"
    
    # Check heading order
    if violations=$(check_heading_order "$file"); then
        echo "✅ $REL_PATH"
        FILES_PASSED=$((FILES_PASSED + 1))
    else
        echo "❌ $REL_PATH"
        echo "$violations" | sed 's/^/   /'
        EXIT_CODE=1
    fi
done < <(find . -path "*/.git" -prune -o -name "*.md" -type f -print0)

echo ""
echo "=================================================="
echo "Summary: $FILES_PASSED/$FILES_CHECKED files have proper heading order"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All markdown files have proper heading order"
else
    echo "❌ Some markdown files have heading order violations"
    echo ""
    echo "Heading order rules (WCAG 2.1):"
    echo "1. First heading must be H1 (#)"
    echo "2. Headings should not skip levels (e.g., don't go from H2 to H4)"
    echo "3. Headings can decrease by any amount (e.g., H4 to H2 is OK)"
    echo ""
    echo "Reference: https://dequeuniversity.com/rules/axe/4.11/heading-order"
fi

exit $EXIT_CODE

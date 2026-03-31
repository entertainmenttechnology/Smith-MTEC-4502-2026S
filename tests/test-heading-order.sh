#!/bin/bash
# Test script to validate heading order in markdown files
# Ensures headings increase by only one level at a time (WCAG 2.1 compliance)
# See: https://dequeuniversity.com/rules/axe/4.11/heading-order

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
    local violations=0
    
    while IFS= read -r line; do
        ((line_num++))
        
        # Skip empty lines and lines that don't start with #
        if [[ ! "$line" =~ ^#+[[:space:]] ]]; then
            continue
        fi
        
        # Count the number of # characters
        heading="${line%%[^#]*}"
        current_level=${#heading}
        
        # Check if heading level increases by more than 1
        if [ $prev_level -gt 0 ] && [ $current_level -gt $((prev_level + 1)) ]; then
            if [ $violations -eq 0 ]; then
                echo "❌ $file"
            fi
            echo "   Line $line_num: Heading jumps from h$prev_level to h$current_level"
            echo "   ${line:0:80}"
            violations=$((violations + 1))
        fi
        
        prev_level=$current_level
    done < "$file"
    
    if [ $violations -eq 0 ]; then
        echo "✅ $file"
        return 0
    else
        echo "   Total violations: $violations"
        return 1
    fi
}

# Find all markdown files and check them
while IFS= read -r -d '' file; do
    # Skip hidden directories (like .git)
    if [[ "$file" == *"/.git/"* ]]; then
        continue
    fi
    
    FILES_CHECKED=$((FILES_CHECKED + 1))
    
    if check_heading_order "$file"; then
        FILES_PASSED=$((FILES_PASSED + 1))
    else
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
    echo "Heading levels should only increase by one at a time:"
    echo "  ✅ Correct: h1 → h2 → h3 → h4"
    echo "  ❌ Wrong: h1 → h3 (skips h2)"
    echo "  ❌ Wrong: h2 → h4 (skips h3)"
    echo ""
    echo "See: https://dequeuniversity.com/rules/axe/4.11/heading-order"
fi

exit $EXIT_CODE

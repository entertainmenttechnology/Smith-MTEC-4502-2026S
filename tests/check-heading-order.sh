#!/bin/bash
# Test script to check heading order in markdown files for WCAG 2.1 accessibility compliance
# Ensures heading levels only increase by one at a time
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

while IFS= read -r -d '' file; do
    # Skip hidden directories (like .git)
    if [[ "$file" == *"/.git/"* ]]; then
        continue
    fi
    
    FILES_CHECKED=$((FILES_CHECKED + 1))
    FILE_HAS_ERROR=0
    
    # Extract all headings with their line numbers
    PREV_LEVEL=0
    LINE_NUM=0
    
    while IFS= read -r line; do
        LINE_NUM=$((LINE_NUM + 1))
        
        # Check if line is a heading (starts with one or more #)
        if [[ "$line" =~ ^(#+)[[:space:]] ]]; then
            HEADING="${BASH_REMATCH[1]}"
            LEVEL=${#HEADING}
            
            # First heading should be H1
            if [ $PREV_LEVEL -eq 0 ] && [ $LEVEL -ne 1 ]; then
                echo "❌ $file"
                echo "   Line $LINE_NUM: First heading should be level 1 (H1), found H$LEVEL"
                echo "   Content: ${line:0:80}"
                FILE_HAS_ERROR=1
                EXIT_CODE=1
                break
            fi
            
            # Check if level increases by more than 1
            if [ $PREV_LEVEL -gt 0 ] && [ $LEVEL -gt $((PREV_LEVEL + 1)) ]; then
                echo "❌ $file"
                echo "   Line $LINE_NUM: Heading level jumps from H$PREV_LEVEL to H$LEVEL (can only increase by 1)"
                echo "   Content: ${line:0:80}"
                FILE_HAS_ERROR=1
                EXIT_CODE=1
                break
            fi
            
            PREV_LEVEL=$LEVEL
        fi
    done < "$file"
    
    if [ $FILE_HAS_ERROR -eq 0 ]; then
        echo "✅ $file"
        FILES_PASSED=$((FILES_PASSED + 1))
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
    echo "  1. Ensure first heading is H1 (# Title)"
    echo "  2. Ensure heading levels only increase by one (H1 → H2 → H3, not H1 → H3)"
    echo "  3. Heading levels can decrease by any amount (H3 → H1 is OK)"
    echo ""
    echo "Reference: https://dequeuniversity.com/rules/axe/4.11/heading-order"
fi

exit $EXIT_CODE

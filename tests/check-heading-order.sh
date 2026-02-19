#!/bin/bash
# Test script to check markdown files have proper heading order for accessibility compliance
# This ensures WCAG 2.1 compliance by validating that heading levels only increase by one
# Implements axe rule: https://dequeuniversity.com/rules/axe/4.11/heading-order

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
    
    # Extract heading levels from the file (ignoring headings in code blocks)
    # This simple approach looks for lines starting with # but not inside code blocks
    in_code_block=false
    prev_level=0
    line_num=0
    file_has_error=false
    
    while IFS= read -r line; do
        line_num=$((line_num + 1))
        
        # Track code blocks (triple backticks)
        if [[ "$line" =~ ^'```' ]]; then
            if $in_code_block; then
                in_code_block=false
            else
                in_code_block=true
            fi
            continue
        fi
        
        # Skip lines inside code blocks and bullet points/lists with headings
        if $in_code_block || [[ "$line" =~ ^[[:space:]]*[\*\-][[:space:]]+### ]]; then
            continue
        fi
        
        # Check if line is a heading (starts with one or more #)
        if [[ "$line" =~ ^(#+)[[:space:]]+ ]]; then
            level=${#BASH_REMATCH[1]}
            
            # First heading should be level 1
            if [ $prev_level -eq 0 ]; then
                if [ $level -ne 1 ]; then
                    echo "❌ $file:$line_num"
                    echo "   First heading is level $level, should be level 1"
                    echo "   Line: ${line:0:80}"
                    file_has_error=true
                fi
            # Subsequent headings should not skip levels
            elif [ $level -gt $((prev_level + 1)) ]; then
                echo "❌ $file:$line_num"
                echo "   Heading level jumped from $prev_level to $level (should increase by 1 at most)"
                echo "   Line: ${line:0:80}"
                file_has_error=true
            fi
            
            prev_level=$level
        fi
    done < "$file"
    
    if [ "$file_has_error" = true ]; then
        EXIT_CODE=1
    else
        echo "✅ $file"
        FILES_PASSED=$((FILES_PASSED + 1))
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
    echo "To fix: Ensure headings only increase by one level at a time"
    echo "Example: # Title → ## Section → ### Subsection (NOT # Title → ### Subsection)"
    echo "Learn more: https://dequeuniversity.com/rules/axe/4.11/heading-order"
fi

exit $EXIT_CODE

#!/bin/bash
# Test script to verify heading order compliance for the Session Resume Development Assignment
# This test ensures the specific axe violation reported in the issue is fixed
# Reference: https://dequeuniversity.com/rules/axe/4.11/heading-order

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

FILE="assignments/11_Session Resume Development Assignment.md"

echo "Testing heading order for $FILE..."
echo "=================================================="

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
                echo "❌ Line $line_num: First heading is level $level, should be level 1"
                echo "   ${line:0:80}"
                error_found=1
            # Subsequent headings should not skip levels
            elif [[ $prev_level -gt 0 && $level -gt $((prev_level + 1)) ]]; then
                echo "❌ Line $line_num: Heading level jumped from $prev_level to $level (should only increase by 1)"
                echo "   ${line:0:80}"
                error_found=1
            fi
            
            prev_level=$level
        fi
    done < "$file"
    
    return $error_found
}

if [ ! -f "$FILE" ]; then
    echo "❌ File not found: $FILE"
    exit 1
fi

if check_heading_order "$FILE"; then
    echo "✅ $FILE has proper heading order"
    echo ""
    echo "Heading structure verified:"
    grep "^#" "$FILE" | head -10
    echo ""
    echo "✅ Test passed: The axe violation for heading-order has been fixed"
    exit 0
else
    echo "❌ $FILE has heading order issues"
    echo ""
    echo "To fix:"
    echo "  1. Ensure the first heading is level 1 (# Heading)"
    echo "  2. Ensure heading levels only increase by one"
    echo ""
    echo "❌ Test failed: The axe violation for heading-order still exists"
    exit 1
fi

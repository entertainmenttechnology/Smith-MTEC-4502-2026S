#!/bin/bash
# Test script to check markdown files have proper heading order for accessibility compliance
# This ensures WCAG 2.1 compliance by validating that heading levels only increase by one

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

# Function to check a single file
check_file() {
    local file="$1"
    FILES_CHECKED=$((FILES_CHECKED + 1))
    
    # Extract all headings and their levels
    local prev_level=0
    local line_num=0
    local file_issues=0
    local seen_levels=()
    local first_heading_level=""
    
    while IFS= read -r line; do
        line_num=$((line_num + 1))
        
        # Match markdown headings (# through ######)
        if [[ "$line" =~ ^(#{1,6})[[:space:]]+ ]]; then
            local hashes="${BASH_REMATCH[1]}"
            local level=${#hashes}
            
            # Store first heading level
            if [ -z "$first_heading_level" ]; then
                first_heading_level=$level
            fi
            
            # Track seen levels
            if [[ ! " ${seen_levels[@]} " =~ " ${level} " ]]; then
                seen_levels+=($level)
            fi
            
            # Check if heading level increases by more than 1
            if [ $prev_level -gt 0 ] && [ $level -gt $((prev_level + 1)) ]; then
                echo "  ⚠️  Line $line_num: Heading level skipped from H$prev_level to H$level"
                file_issues=$((file_issues + 1))
            fi
            
            prev_level=$level
        fi
    done < "$file"
    
    # Check if document starts with H1
    if [ -n "$first_heading_level" ] && [ "$first_heading_level" -ne 1 ]; then
        echo "  ⚠️  Document starts with H$first_heading_level instead of H1"
        file_issues=$((file_issues + 1))
    fi
    
    # Check for gaps in heading levels
    if [ ${#seen_levels[@]} -gt 0 ]; then
        # Sort the seen levels
        IFS=$'\n' sorted_levels=($(sort -n <<<"${seen_levels[*]}"))
        unset IFS
        
        local max_level=${sorted_levels[-1]}
        
        # Check each level from 1 to max
        for ((i=1; i<=max_level; i++)); do
            if [[ ! " ${seen_levels[@]} " =~ " ${i} " ]]; then
                echo "  ⚠️  Document uses H$max_level but is missing H$i"
                file_issues=$((file_issues + 1))
            fi
        done
    fi
    
    if [ $file_issues -eq 0 ]; then
        echo "✅ $file"
        FILES_PASSED=$((FILES_PASSED + 1))
    else
        echo "❌ $file ($file_issues issue(s))"
        EXIT_CODE=1
    fi
}

# Find and check all markdown files
while IFS= read -r -d '' file; do
    # Skip hidden directories (like .git)
    if [[ "$file" == *"/.git/"* ]]; then
        continue
    fi
    
    check_file "$file"
done < <(find . -name "*.md" -type f -print0 | grep -zv ".git")

echo ""
echo "===================================================="
echo "Summary: $FILES_PASSED/$FILES_CHECKED files have valid heading order"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All markdown files have proper heading order"
else
    echo "❌ Some markdown files have heading order issues"
    echo ""
    echo "WCAG 2.1 Guidelines for Heading Order:"
    echo "- Documents should start with an H1 heading"
    echo "- Heading levels should not skip (e.g., H1 -> H3 is invalid)"
    echo "- You can decrease heading levels by any amount (e.g., H3 -> H1 is valid)"
    echo "- All heading levels from H1 to the highest used level should be present"
fi

exit $EXIT_CODE

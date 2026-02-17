#!/bin/bash
# Script to check heading hierarchy in markdown files
# Ensures headings follow proper nesting (H1 -> H2 -> H3, etc.) without skipping levels
# Per WCAG 2.1, heading levels should only INCREASE by one level at a time
# Decreasing levels (e.g., H3 -> H2) is acceptable as it represents closing sections

set -e

EXIT_CODE=0
FILES_WITH_ISSUES=()

# Function to check heading hierarchy in a single file
check_file_headings() {
    local file="$1"
    local issues=()
    local prev_level=0
    local line_num=0
    
    echo "Checking: $file"
    
    # Read file line by line
    while IFS= read -r line; do
        ((line_num++))
        
        # Check if line is a heading (starts with #)
        if [[ "$line" =~ ^(#{1,6})[[:space:]] ]]; then
            # Count the number of # characters
            heading="${BASH_REMATCH[1]}"
            current_level=${#heading}
            
            # Check if heading level jumps more than 1 from previous
            if [ $prev_level -gt 0 ] && [ $current_level -gt $((prev_level + 1)) ]; then
                issues+=("Line $line_num: Heading level jumps from H$prev_level to H$current_level (skipped levels)")
            fi
            
            prev_level=$current_level
        fi
    done < "$file"
    
    # Report issues
    if [ ${#issues[@]} -gt 0 ]; then
        echo "  ❌ FAILED - Found ${#issues[@]} heading hierarchy issue(s):"
        for issue in "${issues[@]}"; do
            echo "    - $issue"
        done
        FILES_WITH_ISSUES+=("$file")
        return 1
    else
        echo "  ✅ PASSED - No heading hierarchy issues found"
        return 0
    fi
}

# Find all markdown files (excluding .git directory)
echo "=========================================="
echo "Checking Markdown Heading Hierarchy"
echo "=========================================="
echo ""

while IFS= read -r -d '' file; do
    if ! check_file_headings "$file"; then
        EXIT_CODE=1
    fi
    echo ""
done < <(find . -name "*.md" -type f ! -path "./.git/*" -print0 | sort -z)

# Summary
echo "=========================================="
echo "Summary"
echo "=========================================="
if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All markdown files have correct heading hierarchy!"
else
    echo "❌ Found heading hierarchy issues in ${#FILES_WITH_ISSUES[@]} file(s):"
    for file in "${FILES_WITH_ISSUES[@]}"; do
        echo "  - $file"
    done
    echo ""
    echo "Please fix heading hierarchy issues to comply with WCAG 2.1 accessibility standards."
    echo "Headings should increase by only one level at a time (e.g., H1 -> H2 -> H3)."
fi

exit $EXIT_CODE
#!/bin/bash
# Validates that markdown files have proper heading order (no skipping levels)
# This ensures WCAG 2.1 heading order compliance

EXIT_CODE=0

echo "Validating markdown heading order..."

# Find all markdown files (excluding .git directory)
while IFS= read -r file; do
    echo "Checking: $file"
    
    # Extract heading levels from the file
    # Get lines starting with # and count the number of # characters
    prev_level=0
    line_num=0
    
    while IFS= read -r line; do
        ((line_num++))
        
        # Skip empty lines
        if [[ -z "$line" ]]; then
            continue
        fi
        
        # Check if line starts with #
        if [[ "$line" =~ ^#{1,6}[[:space:]] ]]; then
            # Count the number of # characters
            heading="${line%%[^#]*}"
            level=${#heading}
            
            # First heading can be any level
            if [[ $prev_level -eq 0 ]]; then
                prev_level=$level
                continue
            fi
            
            # Check that we don't skip levels (can go up by 1, or down any amount)
            if [[ $level -gt $((prev_level + 1)) ]]; then
                echo "ERROR: $file:$line_num - Heading level $level follows level $prev_level (skips a level)"
                echo "  Line: $line"
                EXIT_CODE=1
            fi
            
            prev_level=$level
        fi
    done < "$file"
    
done < <(find . -name "*.md" -type f | grep -v ".git")

if [[ $EXIT_CODE -eq 0 ]]; then
    echo "✓ All markdown files have valid heading order"
else
    echo "✗ Some markdown files have heading order violations"
fi

exit $EXIT_CODE

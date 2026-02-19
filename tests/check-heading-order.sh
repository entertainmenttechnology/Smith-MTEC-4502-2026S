#!/bin/bash
# Test script to check heading order in markdown files for accessibility compliance
# Ensures heading levels only increase by one (h1 -> h2 -> h3, not h1 -> h3)
# This validates WCAG 2.1 heading-order compliance

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

echo "Checking markdown files for proper heading order..."
echo "===================================================="
echo ""

EXIT_CODE=0
FILES_CHECKED=0
FILES_WITH_ISSUES=0

check_file_heading_order() {
    local file="$1"
    local violations=0
    local prev_level=0
    local line_num=0
    
    while IFS= read -r line; do
        line_num=$((line_num + 1))
        
        # Check if line is a heading
        if [[ "$line" =~ ^#{1,6}[[:space:]] ]]; then
            # Count the number of # symbols
            local level=0
            for ((i=0; i<${#line}; i++)); do
                if [[ "${line:i:1}" == "#" ]]; then
                    level=$((level + 1))
                else
                    break
                fi
            done
            
            # Check if this is the first heading
            if [ $prev_level -eq 0 ]; then
                prev_level=$level
            else
                # Check if level increased by more than one
                if [ $level -gt $((prev_level + 1)) ]; then
                    echo "  ❌ Line $line_num: Heading level skipped from h$prev_level to h$level"
                    echo "     Content: ${line:0:80}"
                    violations=$((violations + 1))
                fi
                prev_level=$level
            fi
        fi
    done < "$file"
    
    return $violations
}

while IFS= read -r -d '' file; do
    # Skip hidden directories (like .git)
    if [[ "$file" == *"/.git/"* ]] || [[ "$file" == *"/node_modules/"* ]]; then
        continue
    fi
    
    FILES_CHECKED=$((FILES_CHECKED + 1))
    REL_PATH="${file#$REPO_ROOT/}"
    
    # Check heading order in this file
    if check_file_heading_order "$file"; then
        echo "✅ $REL_PATH"
    else
        FILES_WITH_ISSUES=$((FILES_WITH_ISSUES + 1))
        EXIT_CODE=1
    fi
done < <(find . -name "*.md" -type f -print0 | grep -zv ".git")

echo ""
echo "===================================================="
echo "Summary: $FILES_CHECKED files checked, $FILES_WITH_ISSUES with heading order issues"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All markdown files have proper heading order"
else
    echo "❌ Some markdown files have heading order violations"
    echo ""
    echo "To fix: Ensure heading levels only increase by one at a time"
    echo "Valid: h1 → h2 → h3 or h3 → h2 → h1"
    echo "Invalid: h1 → h3 (skipping h2) or h2 → h4 (skipping h3)"
    echo ""
    echo "This is required for WCAG 2.1 accessibility compliance (heading-order rule)"
fi

exit $EXIT_CODE

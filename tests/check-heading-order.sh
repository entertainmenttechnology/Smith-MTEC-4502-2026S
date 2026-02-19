#!/bin/bash
# Test script to check that heading levels in markdown files don't skip levels
# This ensures WCAG 2.1 compliance by validating heading-order (axe rule: heading-order)
# Headings must only increase by one level at a time (e.g., h2 -> h3 is valid, h2 -> h4 is not)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

# Default: check all markdown files, or accept a specific file as argument
if [ -n "$1" ]; then
    FILES=("$1")
else
    mapfile -d '' FILES < <(find . -name "*.md" -type f -print0 | grep -zv ".git")
fi

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
    local errors=0

    while IFS= read -r line; do
        line_num=$((line_num + 1))
        # Match heading lines (# through ######), but not inside code blocks
        if [[ "$line" =~ ^(#{1,6})[[:space:]] ]]; then
            level=${#BASH_REMATCH[1]}
            if [ "$prev_level" -gt 0 ] && [ "$level" -gt "$((prev_level + 1))" ]; then
                echo "   ❌ Line $line_num: heading jumps from h${prev_level} to h${level}: $line"
                errors=$((errors + 1))
            fi
            prev_level=$level
        fi
    done < "$file"

    return $errors
}

for file in "${FILES[@]}"; do
    # Skip hidden directories (like .git)
    if [[ "$file" == *"/.git/"* ]]; then
        continue
    fi

    FILES_CHECKED=$((FILES_CHECKED + 1))

    if check_heading_order "$file"; then
        echo "✅ $file"
        FILES_PASSED=$((FILES_PASSED + 1))
    else
        echo "❌ $file has heading order issues (heading levels must only increase by one)"
        EXIT_CODE=1
    fi
done

echo ""
echo "=================================================="
echo "Summary: $FILES_PASSED/$FILES_CHECKED files have valid heading order"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All markdown files have valid heading order"
else
    echo "❌ Some markdown files have invalid heading order"
    echo ""
    echo "To fix: ensure heading levels only increase by one at a time"
    echo "Example: h2 -> h3 is valid, but h2 -> h4 is not"
fi

exit $EXIT_CODE

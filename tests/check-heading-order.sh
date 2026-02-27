#!/bin/bash
# Test script to check markdown files have valid heading order for accessibility compliance
# Ensures heading levels only increase by one, per WCAG 2.1 / axe heading-order rule

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

echo "Checking markdown files for valid heading order..."
echo "=================================================="
echo ""

EXIT_CODE=0
FILES_CHECKED=0
FILES_PASSED=0

check_heading_order() {
    local file="$1"
    local prev_level=0
    local line_num=0
    local violations=""
    local in_code_block=0

    while IFS= read -r line; do
        line_num=$((line_num + 1))
        # Track fenced code blocks to skip headings inside them
        if [[ "$line" =~ ^(\`\`\`|~~~) ]]; then
            if [[ $in_code_block -eq 0 ]]; then
                in_code_block=1
            else
                in_code_block=0
            fi
            continue
        fi
        [[ $in_code_block -eq 1 ]] && continue
        # Match markdown headings (# through ######)
        if [[ "$line" =~ ^(#{1,6})[[:space:]] ]]; then
            local hashes="${BASH_REMATCH[1]}"
            local level=${#hashes}
            # Only flag if heading level increases by more than one
            if [[ $prev_level -gt 0 && $level -gt $((prev_level + 1)) ]]; then
                violations="$violations\n   Line $line_num: heading jumps from h${prev_level} to h${level}: ${line:0:60}"
            fi
            prev_level=$level
        fi
    done < "$file"

    echo "$violations"
}

while IFS= read -r -d '' file; do
    FILES_CHECKED=$((FILES_CHECKED + 1))

    violations=$(check_heading_order "$file")

    if [[ -z "$violations" ]]; then
        echo "✅ $file"
        FILES_PASSED=$((FILES_PASSED + 1))
    else
        echo "❌ $file"
        echo -e "$violations"
        EXIT_CODE=1
    fi
done < <(find . -name "*.md" -type f -print0 | grep -zv ".git")

echo ""
echo "=================================================="
echo "Summary: $FILES_PASSED/$FILES_CHECKED files have valid heading order"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All markdown files have valid heading order"
else
    echo "❌ Some markdown files have invalid heading order"
    echo ""
    echo "To fix: ensure heading levels only increase by one (e.g., h2 -> h3, not h2 -> h4)"
fi

exit $EXIT_CODE

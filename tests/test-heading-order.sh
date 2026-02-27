#!/bin/bash
# Test script to check markdown files have valid heading order for accessibility compliance
# Heading levels should only increase by one (WCAG 2.1 / axe heading-order rule)

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
    local violations=0

    while IFS= read -r line; do
        # Match heading lines (1-6 # characters followed by a space)
        if [[ "$line" =~ ^(#{1,6})[[:space:]] ]]; then
            local hashes="${BASH_REMATCH[1]}"
            local level=${#hashes}
            if [[ $prev_level -gt 0 && $((level - prev_level)) -gt 1 ]]; then
                echo "   Heading order violation: jumped from H${prev_level} to H${level}: ${line:0:80}"
                violations=$((violations + 1))
            fi
            prev_level=$level
        fi
    done < "$file"

    return $violations
}

while IFS= read -r -d '' file; do
    # Skip hidden directories (like .git)
    if [[ "$file" == *"/.git/"* ]]; then
        continue
    fi

    FILES_CHECKED=$((FILES_CHECKED + 1))

    if check_heading_order "$file"; then
        echo "✅ $file"
        FILES_PASSED=$((FILES_PASSED + 1))
    else
        echo "❌ $file"
        EXIT_CODE=1
    fi
done < <(find . -name "*.md" -type f -print0 | grep -zv ".git")

echo ""
echo "=================================================="
echo "Summary: $FILES_PASSED/$FILES_CHECKED files have valid heading order"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All markdown files have valid heading order"
else
    echo "❌ Some markdown files have heading order violations"
    echo ""
    echo "To fix: Ensure heading levels only increase by one at a time."
    echo "Example: H1 -> H2 -> H3 is valid; H1 -> H3 skips H2 and is invalid."
fi

exit $EXIT_CODE

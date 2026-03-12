#!/bin/bash
# Test script to check markdown files for link accessibility
# Ensures links in text blocks are distinguishable without relying on color
# Addresses WCAG 2.1 / axe rule: link-in-text-block
# See: https://dequeuniversity.com/rules/axe/4.11/link-in-text-block

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

echo "Checking markdown files for link accessibility (link-in-text-block)..."
echo "======================================================================"
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
    FILE_PASSED=true

    # Check for non-descriptive link text (links that rely on color/position to convey meaning)
    # These link texts do not convey the purpose of the link without surrounding context
    if grep -inE '\[(here|click here|read more|more|this|link|url|this link)\]\(' "$file" > /dev/null 2>&1; then
        matches=$(grep -inE '\[(here|click here|read more|more|this|link|url|this link)\]\(' "$file")
        echo "❌ $file"
        echo "   Non-descriptive link text found (links must be distinguishable without relying on color):"
        while IFS= read -r match; do
            echo "     $match"
        done <<< "$matches"
        echo "   Fix: Replace vague link text with descriptive text that conveys the link purpose"
        FILE_PASSED=false
        EXIT_CODE=1
    fi

    if [ "$FILE_PASSED" = true ]; then
        echo "✅ $file"
        FILES_PASSED=$((FILES_PASSED + 1))
    fi

done < <(find . -name "*.md" -type f -print0)

echo ""
echo "======================================================================"
echo "Summary: $FILES_PASSED/$FILES_CHECKED files pass link accessibility checks"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All markdown files pass link accessibility checks"
else
    echo "❌ Some markdown files have link accessibility issues"
    echo ""
    echo "To fix: Replace non-descriptive link text ('here', 'click here', 'read more', etc.)"
    echo "with meaningful text that conveys the link purpose without relying on color or position."
    echo "Example: Instead of [click here](url), use [View the WCAG 2.1 Guidelines](url)"
    echo ""
    echo "Reference: https://dequeuniversity.com/rules/axe/4.11/link-in-text-block"
fi

exit $EXIT_CODE

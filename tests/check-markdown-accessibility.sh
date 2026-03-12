#!/bin/bash
# Test script to check markdown files have level-one headings for accessibility compliance
# This ensures WCAG 2.1 compliance by validating that pages have proper heading structure
# and that content will render inside landmark regions (axe 'region' rule).

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

echo "Checking markdown files for accessibility compliance..."
echo "======================================================="
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
    FILE_OK=1
    
    # Check 1: first non-empty line starts with "# " (level-one heading)
    first_line=$(head -20 "$file" | grep -v '^[[:space:]]*$' | head -1)
    
    if [[ "$first_line" =~ ^#[[:space:]]+ ]]; then
        : # heading present
    else
        echo "❌ $file"
        echo "   First non-empty line: ${first_line:0:80}"
        echo "   Expected: Line starting with '# ' (level-one heading)"
        EXIT_CODE=1
        FILE_OK=0
    fi
    
    # Check 4: No raw HTML block elements that could render outside landmark regions
    # (axe 'region' rule: all page content should be contained by landmarks)
    raw_html=$(grep -nE "^<(div|p|ul|ol|li|dl|dt|dd|table|h[1-6]|blockquote|pre|figure|figcaption|address|details|summary|hr)(\s|>|/)" "$file" 2>/dev/null || true)
    if [ -n "$raw_html" ]; then
        if [ $FILE_OK -eq 1 ]; then
            echo "❌ $file"
        fi
        echo "   Raw HTML block elements found that may render outside landmark regions:"
        echo "$raw_html" | head -3 | while IFS= read -r line; do
            echo "   $line"
        done
        EXIT_CODE=1
        FILE_OK=0
    fi
    
    if [ $FILE_OK -eq 1 ]; then
        echo "✅ $file"
        FILES_PASSED=$((FILES_PASSED + 1))
    fi
done < <(find . -name "*.md" -type f -print0 | grep -zv ".git")

echo ""
echo "======================================================="
echo "Summary: $FILES_PASSED/$FILES_CHECKED files pass accessibility checks"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All markdown files pass accessibility checks"
else
    echo "❌ Some markdown files have accessibility issues"
    echo ""
    echo "To fix heading issues: Add a level-one heading (starting with '# ') as the first non-empty line"
    echo "Example: # Page Title"
    echo ""
    echo "To fix landmark issues: Remove raw HTML block elements or wrap them in a landmark element"
    echo "See: https://dequeuniversity.com/rules/axe/4.11/region"
fi

exit $EXIT_CODE

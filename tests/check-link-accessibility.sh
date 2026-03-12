#!/bin/bash
# Test script to check markdown files have no links without discernible text
# This ensures WCAG 2.1 compliance with the link-name rule:
#   - Links must have discernible text
#   - Image links must have alt text on the image
#
# Checks for:
#   - Empty link text: [](url)
#   - Image links with missing alt text: [![](url)](link)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

echo "Checking markdown files for links with discernible text..."
echo "==========================================================="
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
    FILE_PASSED=1

    # Check for empty link text: [](url) pattern
    # Strip inline code (backtick-wrapped content) before checking to avoid false positives
    empty_links=$(grep -n '\[\](' "$file" 2>/dev/null | sed 's/`[^`]*`//g' | grep '\[\](' || true)
    if [[ -n "$empty_links" ]]; then
        echo "❌ $file"
        echo "   Links with empty text found:"
        while IFS= read -r line; do
            echo "     $line"
        done <<< "$empty_links"
        FILE_PASSED=0
        EXIT_CODE=1
    fi

    # Check for image links with no alt text: [![](image)](link) pattern
    # Strip inline code (backtick-wrapped content) before checking to avoid false positives
    empty_img_links=$(grep -n '!\[\](' "$file" 2>/dev/null | sed 's/`[^`]*`//g' | grep '!\[\](' || true)
    if [[ -n "$empty_img_links" ]]; then
        echo "❌ $file"
        echo "   Image links without alt text found:"
        while IFS= read -r line; do
            echo "     $line"
        done <<< "$empty_img_links"
        FILE_PASSED=0
        EXIT_CODE=1
    fi

    if [[ $FILE_PASSED -eq 1 ]]; then
        echo "✅ $file"
        FILES_PASSED=$((FILES_PASSED + 1))
    fi
done < <(find . -name "*.md" -type f -print0)

echo ""
echo "==========================================================="
echo "Summary: $FILES_PASSED/$FILES_CHECKED files have no link accessibility issues"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All markdown files have links with discernible text"
else
    echo "❌ Some markdown files have links without discernible text"
    echo ""
    echo "To fix: Ensure all links have descriptive text and all image links have alt text"
    echo "Example good link:  [Visit Job Listings](https://example.com)"
    echo "Example bad link:   [](https://example.com)"
    echo "Example good image link: [![GitHub logo](logo.png)](https://github.com)"
    echo "Example bad image link:  [![](logo.png)](https://github.com)"
fi

exit $EXIT_CODE

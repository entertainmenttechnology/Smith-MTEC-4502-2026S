#!/bin/bash
# Test script to check markdown files for links with discernible text
# This ensures WCAG 2.1 / axe link-name rule compliance by validating that
# all links in markdown files have accessible text (non-empty link text,
# or images with alt text used as link content).
#
# Addresses: https://dequeuniversity.com/rules/axe/4.11/link-name

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
VIOLATIONS_FOUND=0

while IFS= read -r -d '' file; do
    # Skip hidden directories (like .git)
    if [[ "$file" == *"/.git/"* ]]; then
        continue
    fi

    FILES_CHECKED=$((FILES_CHECKED + 1))
    FILE_VIOLATIONS=0

    # Check for empty link text: [](...) or [ ](...)
    # Matches Markdown links with empty or whitespace-only text, anywhere in the line
    while IFS= read -r line_info; do
        line_num=$(echo "$line_info" | cut -d: -f1)
        line_content=$(echo "$line_info" | cut -d: -f2-)
        echo "❌ $file"
        echo "   Line $line_num: $line_content"
        echo "   Issue: Link has empty text (no discernible text for screen readers)"
        FILE_VIOLATIONS=$((FILE_VIOLATIONS + 1))
        VIOLATIONS_FOUND=$((VIOLATIONS_FOUND + 1))
        EXIT_CODE=1
    done < <(grep -nP '\[\s*\]\s*\(' "$file" 2>/dev/null || true)

    # Check for image-only links where the image has no alt text:
    # [![](image-url)](link-url) — image with empty alt text used as sole link content
    while IFS= read -r line_info; do
        line_num=$(echo "$line_info" | cut -d: -f1)
        line_content=$(echo "$line_info" | cut -d: -f2-)
        echo "❌ $file"
        echo "   Line $line_num: $line_content"
        echo "   Issue: Link uses image with empty alt text as sole content (no discernible text)"
        FILE_VIOLATIONS=$((FILE_VIOLATIONS + 1))
        VIOLATIONS_FOUND=$((VIOLATIONS_FOUND + 1))
        EXIT_CODE=1
    done < <(grep -nP '\[!\[\s*\]\([^\)]*\)\]\(' "$file" 2>/dev/null || true)

    if [ "$FILE_VIOLATIONS" -eq 0 ]; then
        echo "✅ $file"
        FILES_PASSED=$((FILES_PASSED + 1))
    fi
done < <(find . -name "*.md" -type f -print0 | grep -zv ".git")

echo ""
echo "==========================================================="
echo "Summary: $FILES_PASSED/$FILES_CHECKED files have no link-name violations"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All markdown links have discernible text"
else
    echo "❌ $VIOLATIONS_FOUND link(s) found without discernible text"
    echo ""
    echo "To fix: Ensure every Markdown link has non-empty link text."
    echo "  Good:  [Visit City Tech](https://www.citytech.cuny.edu/)"
    echo "  Good:  [![City Tech logo](logo.png)](https://www.citytech.cuny.edu/)"
    echo "  Bad:   [](https://www.citytech.cuny.edu/)"
    echo "  Bad:   [![](logo.png)](https://www.citytech.cuny.edu/)"
    echo ""
    echo "Reference: https://dequeuniversity.com/rules/axe/4.11/link-name"
fi

exit $EXIT_CODE

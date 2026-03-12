#!/bin/bash
# Script to check that all markdown links have discernible (non-empty) link text
# This helps prevent WCAG 2.1 / axe link-name accessibility violations where
# links lack visible or accessible text content.
#
# Checks for:
#   - Empty link text:          [](url)
#   - Whitespace-only text:     [   ](url)
#   - Image-only links without alt text: [![](img)](url)  (alt="" or missing)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "Checking markdown files for links with discernible text..."
echo "==========================================================="

EXIT_CODE=0
CHECKED=0
ISSUES=0

while IFS= read -r -d '' file; do
    CHECKED=$((CHECKED + 1))
    REL_PATH="${file#$REPO_ROOT/}"
    FILE_ISSUES=0

    # Find lines with markdown links [text](url)
    # Flag links where the text portion is empty or whitespace-only
    while IFS= read -r line_info; do
        lineno="${line_info%%:*}"
        content="${line_info#*:}"

        # Match [](url) or [  ](url) — empty/whitespace link text
        if echo "$content" | grep -qP '(?<!\!)\[\s*\]\('; then
            echo "❌ $REL_PATH (line $lineno): link with empty text found"
            echo "   $content"
            FILE_ISSUES=$((FILE_ISSUES + 1))
            ISSUES=$((ISSUES + 1))
            EXIT_CODE=1
        fi

        # Match image-only links: [![alt](img)](url) where alt is empty
        # e.g.  [![](img.png)](url)
        if echo "$content" | grep -qP '\[!\[\s*\]\([^)]*\)\]\('; then
            echo "❌ $REL_PATH (line $lineno): image link with empty alt text found"
            echo "   $content"
            FILE_ISSUES=$((FILE_ISSUES + 1))
            ISSUES=$((ISSUES + 1))
            EXIT_CODE=1
        fi
    done < <(grep -nP '\[[^\]]*\]\(' "$file" 2>/dev/null || true)

    if [ "$FILE_ISSUES" -eq 0 ]; then
        echo "✅ $REL_PATH"
    fi
done < <(find "$REPO_ROOT" -name "*.md" -type f ! -path "*/\.git/*" ! -path "*/node_modules/*" -print0)

echo ""
echo "==========================================================="
echo "Results: Checked $CHECKED files, $ISSUES link-text issue(s) found"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All markdown links have discernible text!"
else
    echo "❌ Some links are missing discernible text."
    echo ""
    echo "To fix: Ensure every markdown link has non-empty, meaningful text:"
    echo "  Bad:  [](https://example.com)"
    echo "  Good: [Example site](https://example.com)"
    echo ""
    echo "For image links, add a descriptive alt attribute:"
    echo "  Bad:  [![](logo.png)](https://example.com)"
    echo "  Good: [![Example logo](logo.png)](https://example.com)"
    echo ""
    echo "This is required for WCAG 2.1 Success Criterion 2.4.4 (Link Purpose)"
    echo "and the axe link-name rule."
fi

exit $EXIT_CODE

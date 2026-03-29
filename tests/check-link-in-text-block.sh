#!/bin/bash
# Test script to check inline links in markdown files for accessibility compliance.
# Addresses WCAG 2.1 / axe rule: link-in-text-block
#
# Links that appear inline within a paragraph of text must be distinguishable
# from the surrounding text without relying solely on color. Using descriptive
# link text (rather than bare URLs) helps meet this requirement.
#
# This script flags:
#   - Links where the link text IS the URL (e.g., [https://example.com](https://example.com))
#     when they appear inline within a sentence (i.e., not on their own line).
#
# See: https://dequeuniversity.com/rules/axe/4.11/link-in-text-block

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

echo "Checking markdown files for inaccessible inline links (link-in-text-block)..."
echo "=========================================================================="
echo ""

EXIT_CODE=0
FILES_CHECKED=0
FILES_WITH_ISSUES=0

while IFS= read -r -d '' file; do
    # Skip hidden directories (like .git)
    if [[ "$file" == *"/.git/"* ]]; then
        continue
    fi

    FILES_CHECKED=$((FILES_CHECKED + 1))
    FILE_HAS_ISSUE=0

    # Read the file line by line, looking for inline links with URL-as-text
    # Pattern: a markdown link [text](url) where text == url AND the link is
    # NOT the only content on the line (i.e., it appears within surrounding text).
    while IFS= read -r line; do
        # Skip code blocks (lines starting with 4 spaces or inside ``` blocks)
        # Simple heuristic: skip lines starting with spaces/tabs (code blocks)
        if [[ "$line" =~ ^[[:space:]]{4} ]]; then
            continue
        fi

        # Find markdown links where link text equals the URL
        # Pattern: [URL](URL) where both text and href start with http:// or https://
        # Uses a PCRE backreference to confirm the text and href are the same URL.
        if echo "$line" | grep -qP '\[(https?://[^\]]+)\]\(\1\)'; then
            # Check that surrounding text exists on the line (link is inline)
            # Strip the link itself and see if there's remaining text
            stripped=$(echo "$line" | sed 's/\[https\?:\/\/[^]]*\]\(https\?:\/\/[^)]*\)//g' | tr -d '[:space:]')
            if [[ -n "$stripped" ]]; then
                echo "  ⚠️  Inline URL-as-text link in: $file"
                echo "     Line: ${line:0:120}"
                echo "     Fix: Replace with descriptive link text, e.g., [MIT Work of the Future](https://...)"
                FILE_HAS_ISSUE=1
                EXIT_CODE=1
            fi
        fi
    done < "$file"

    if [[ $FILE_HAS_ISSUE -eq 0 ]]; then
        echo "✅ $file"
    else
        FILES_WITH_ISSUES=$((FILES_WITH_ISSUES + 1))
    fi
done < <(find . -name "*.md" -type f -print0 | grep -zv '\.git/')

echo ""
echo "=========================================================================="
PASSING=$((FILES_CHECKED - FILES_WITH_ISSUES))
echo "Summary: $PASSING/$FILES_CHECKED files have no inaccessible inline links"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All inline links use descriptive link text"
else
    echo "❌ Some files have inline links where the link text is a bare URL."
    echo ""
    echo "To fix: Replace bare-URL link text with a short, descriptive phrase."
    echo "  Before: [https://example.com](https://example.com)"
    echo "  After:  [Example Website](https://example.com)"
    echo ""
    echo "This ensures links can be distinguished from surrounding text without"
    echo "relying solely on color (WCAG 2.1 / axe rule: link-in-text-block)."
fi

exit $EXIT_CODE

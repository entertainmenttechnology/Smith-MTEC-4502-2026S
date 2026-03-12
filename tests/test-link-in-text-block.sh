#!/bin/bash
# Test script to check that hyperlinks in markdown files are not embedded inside
# italic (muted) text blocks, which causes color contrast failures per WCAG 2.1
# link-in-text-block rule (axe rule: link-in-text-block).
#
# When GitHub renders italic markdown (*...*), the surrounding text is displayed
# in a muted gray color (~#7b7c7d). Links inside italic blocks have a contrast
# ratio of ~1.29:1 against this gray, well below the required 3:1 minimum.
#
# This test prevents regression of the accessibility issue:
# "Links must be distinguishable without relying on color"

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

echo "Checking markdown files for links embedded inside italic text blocks..."
echo "========================================================================"
echo ""

EXIT_CODE=0
FILES_CHECKED=0
FILES_PASSED=0

# Pattern: italic blocks containing markdown links or bare URLs
# Matches single-asterisk italic (*...*) but NOT double-asterisk bold (**...**)
# Uses negative lookbehind/lookahead to distinguish italic from bold
ITALIC_LINK_PATTERN='(?<!\*)\*(?!\*)[^*]*(\[.*\]\(.*\)|<https?://[^>]*>)[^*]*(?<!\*)\*(?!\*)'

while IFS= read -r -d '' file; do
    FILES_CHECKED=$((FILES_CHECKED + 1))
    REL_PATH="${file#$REPO_ROOT/}"

    # Check for links embedded in italic text blocks
    if grep -qP "$ITALIC_LINK_PATTERN" "$file" 2>/dev/null; then
        echo "❌ $REL_PATH"
        echo "   Contains link(s) inside italic (*...*) formatting."
        echo "   Italic text renders in GitHub's muted gray color, causing"
        echo "   insufficient color contrast for embedded links (WCAG 2.1 link-in-text-block)."
        echo "   Offending line(s):"
        grep -nP "$ITALIC_LINK_PATTERN" "$file" 2>/dev/null | sed 's/^/   /'
        echo ""
        EXIT_CODE=1
    else
        echo "✅ $REL_PATH"
        FILES_PASSED=$((FILES_PASSED + 1))
    fi
done < <(find "$REPO_ROOT" -name "*.md" -type f ! -path "*/.git/*" ! -path "*/.github/*" -print0)

echo ""
echo "========================================================================"
echo "Summary: $FILES_PASSED/$FILES_CHECKED files pass link-in-text-block check"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ No links found inside italic text blocks"
else
    echo "❌ Some markdown files have links inside italic text blocks"
    echo ""
    echo "To fix: Remove the italic (*...*) formatting around text that contains"
    echo "hyperlinks, or move the link outside the italic block."
    echo ""
    echo "Example (bad):  *(See the [project page](https://example.com) for details.)*"
    echo "Example (good): (See the [project page](https://example.com) for details.)"
fi

exit $EXIT_CODE

#!/bin/bash
# Test script to check markdown files for inline HTML color styling that
# could cause accessibility color contrast violations (WCAG 2.1 AA).
#
# This script checks that markdown files do not use inline HTML with
# explicit low-contrast color values in style attributes or deprecated
# color attributes. Foreground color #7b7c7d on background #f6f8fa
# (contrast ratio 3.92:1) fails the required 4.5:1 threshold.
#
# Related: WCAG 2.1 Success Criterion 1.4.3 (Contrast Minimum)
# See: https://dequeuniversity.com/rules/axe/4.11/color-contrast

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

echo "Checking markdown files for inline HTML color contrast issues..."
echo "=================================================================="
echo ""

EXIT_CODE=0
FILES_CHECKED=0
FILES_PASSED=0

# Known low-contrast color values (foreground colors that fail 4.5:1
# against the light GitHub background #f6f8fa):
# #7b7c7d (contrast 3.92:1 - FAILS)
# #808080 (contrast 3.95:1 - FAILS)
# #999999 (contrast 2.85:1 - FAILS)
# #aaaaaa (contrast 2.32:1 - FAILS)
LOW_CONTRAST_PATTERN='([Cc]olor[[:space:]]*:[[:space:]]*(#7b7c7d|#808080|#999|#999999|#aaa|#aaaaaa)|[Cc]olor="(#7b7c7d|#808080|#999|#999999|#aaa|#aaaaaa)")'

while IFS= read -r -d '' file; do
    FILES_CHECKED=$((FILES_CHECKED + 1))
    REL_PATH="${file#$REPO_ROOT/}"

    # Check for inline HTML with low-contrast color values
    if grep -qP "$LOW_CONTRAST_PATTERN" "$file" 2>/dev/null; then
        echo "❌ $REL_PATH"
        echo "   Contains inline HTML with potentially low-contrast color values."
        echo "   Matching lines:"
        grep -nP "$LOW_CONTRAST_PATTERN" "$file" | head -5 | sed 's/^/     /'
        echo "   Required contrast ratio: 4.5:1 (WCAG 2.1 AA for normal text)"
        EXIT_CODE=1
    else
        echo "✅ $REL_PATH"
        FILES_PASSED=$((FILES_PASSED + 1))
    fi
done < <(find "$REPO_ROOT" -name "*.md" -type f ! -path "*/\.git/*" ! -path "*/node_modules/*" -print0)

echo ""
echo "=================================================================="
echo "Results: Checked $FILES_CHECKED files, $FILES_PASSED passed"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ No inline HTML color contrast issues found in markdown files."
    echo ""
    echo "Note: This script checks for inline HTML color styling only."
    echo "GitHub-rendered page contrast depends on GitHub's CSS, which may"
    echo "affect elements outside the markdown content (e.g., UI chrome)."
else
    echo "❌ Color contrast issues found in some markdown files."
    echo ""
    echo "To fix: Remove or replace inline HTML color styling with values"
    echo "that meet WCAG 2.1 AA minimum contrast ratio of 4.5:1."
    echo ""
    echo "For reference, these foreground colors meet 4.5:1 contrast"
    echo "against GitHub's light background (#f6f8fa):"
    echo "  - #595959 or darker (e.g., #333333, #000000)"
    echo "  - Use GitHub's default text styling instead of inline colors"
fi

exit $EXIT_CODE

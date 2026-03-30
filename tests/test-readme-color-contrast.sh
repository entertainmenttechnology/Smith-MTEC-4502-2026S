#!/bin/bash
# Test script to check markdown files do not contain inline HTML with
# low-contrast color combinations that would fail WCAG 2.1 AA requirements.
#
# This prevents regression of the color contrast accessibility issue where
# inline HTML <p> elements had insufficient contrast (3.92:1 vs required 4.5:1)
# due to foreground color #7b7c7d on background color #f6f8fa.
#
# Reference: https://dequeuniversity.com/rules/axe/4.11/color-contrast

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

echo "Checking markdown files for inline HTML with low-contrast color combinations..."
echo "==============================================================================="
echo ""

EXIT_CODE=0
FILES_CHECKED=0
FILES_PASSED=0

# Known low-contrast color values in CSS style attributes that fail WCAG 2.1 AA
# (contrast ratio < 4.5:1 for normal text against light backgrounds like #f6f8fa)
# These are matched as CSS property values inside style="..." attributes.
LOW_CONTRAST_COLORS=(
    "color:[[:space:]]*#7b7c7d"
    "color:[[:space:]]*#888888"
    "color:[[:space:]]*#888"
    "color:[[:space:]]*#999999"
    "color:[[:space:]]*#999"
    "color:[[:space:]]*#aaaaaa"
    "color:[[:space:]]*#aaa"
)

while IFS= read -r -d '' file; do
    FILES_CHECKED=$((FILES_CHECKED + 1))
    file_failed=0

    # Check for inline HTML style attributes containing known low-contrast color values
    for color_pattern in "${LOW_CONTRAST_COLORS[@]}"; do
        if grep -qiE "style=['\"][^'\"]*${color_pattern}[^'\"]*['\"]" "$file" 2>/dev/null; then
            if [ $file_failed -eq 0 ]; then
                echo "❌ $file"
                file_failed=1
            fi
            echo "   Found potentially low-contrast color style: ${color_pattern}"
            EXIT_CODE=1
        fi
    done

    if [ $file_failed -eq 0 ]; then
        echo "✅ $file"
        FILES_PASSED=$((FILES_PASSED + 1))
    fi
done < <(find . -name "*.md" -type f ! -path "*/.git/*" -print0)

echo ""
echo "==============================================================================="
echo "Summary: $FILES_PASSED/$FILES_CHECKED files pass color contrast check"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ No inline HTML with known low-contrast color combinations found"
else
    echo "❌ Some markdown files contain inline HTML with potentially low-contrast colors"
    echo ""
    echo "To fix: Remove or update inline HTML style attributes so foreground/background"
    echo "color combinations meet WCAG 2.1 AA minimum contrast ratio of 4.5:1 for"
    echo "normal text (< 18pt or < 14pt bold) and 3:1 for large text."
    echo ""
    echo "Tools to check contrast ratios:"
    echo "  - https://webaim.org/resources/contrastchecker/"
    echo "  - https://dequeuniversity.com/rules/axe/4.11/color-contrast"
fi

exit $EXIT_CODE

#!/bin/bash
# Test script to check markdown files for potential color contrast issues
# Flags standalone italic-only paragraphs (*text*) which can render with
# GitHub's muted text color (#7b7c7d) causing WCAG 2.1 AA contrast failures.
# Also checks for inline HTML with explicit low-contrast color attributes.
#
# WCAG 2.1 AA requires a minimum contrast ratio of 4.5:1 for normal text.
# GitHub renders standalone <em> paragraphs with a muted color (#7b7c7d) on
# its canvas background (#f6f8fa), producing a contrast ratio of only ~3.92:1.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

echo "Checking markdown files for color contrast issues..."
echo "====================================================="
echo ""

EXIT_CODE=0
FILES_CHECKED=0
FILES_PASSED=0
ISSUES_FOUND=0

while IFS= read -r -d '' file; do
    # Skip hidden directories (like .git)
    if [[ "$file" == *"/.git/"* ]]; then
        continue
    fi

    FILES_CHECKED=$((FILES_CHECKED + 1))
    FILE_ISSUES=0

    # Check for standalone italic-only paragraphs (*text* or _text_ as a whole line)
    # These render as <p><em>text</em></p> on GitHub with muted/low-contrast color
    while IFS= read -r line_content; do
        # Match lines that are ONLY italic text (the whole line is *...* or _..._)
        if echo "$line_content" | grep -qE '^\*[^*]+\*$|^_[^_]+_$'; then
            if [ $FILE_ISSUES -eq 0 ]; then
                echo "⚠️  $file"
            fi
            echo "   Standalone italic paragraph (may render with low contrast on GitHub):"
            echo "   > $line_content"
            FILE_ISSUES=$((FILE_ISSUES + 1))
            ISSUES_FOUND=$((ISSUES_FOUND + 1))
            EXIT_CODE=1
        fi
    done < "$file"

    # Check for inline HTML with explicit color attributes that may fail contrast
    # Looks for color values in style attributes or font color attributes
    if grep -qiE 'color:\s*#[0-9a-f]{3,6}|<font[^>]+color=' "$file" 2>/dev/null; then
        if [ $FILE_ISSUES -eq 0 ]; then
            echo "⚠️  $file"
        fi
        echo "   Contains inline color styling — verify contrast ratio meets WCAG 2.1 AA (4.5:1)"
        FILE_ISSUES=$((FILE_ISSUES + 1))
        ISSUES_FOUND=$((ISSUES_FOUND + 1))
        EXIT_CODE=1
    fi

    if [ $FILE_ISSUES -eq 0 ]; then
        echo "✅ $file"
        FILES_PASSED=$((FILES_PASSED + 1))
    fi
done < <(find . -name "*.md" -type f -print0 | grep -zv ".git")

echo ""
echo "====================================================="
echo "Summary: $FILES_PASSED/$FILES_CHECKED files pass color contrast checks"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ No color contrast issues found in markdown files"
else
    echo "⚠️  $ISSUES_FOUND potential color contrast issue(s) found"
    echo ""
    echo "To fix standalone italic paragraphs:"
    echo "  Change: *Description text here.*"
    echo "  To:     Description text here."
    echo "  (Remove the surrounding asterisks to use default high-contrast text)"
    echo ""
    echo "For inline color styling, ensure foreground/background contrast ratio >= 4.5:1"
    echo "Use a contrast checker: https://webaim.org/resources/contrastchecker/"
fi

exit $EXIT_CODE

#!/bin/bash
# Test script to check that markdown files do not use blockquote syntax for decorative quotes.
# On GitHub, blockquotes render with a muted gray text color (~#7b7c7d) on the page background
# (#f6f8fa), producing a contrast ratio of ~3.92 which fails WCAG 2 AA (minimum 4.5:1).
#
# Decorative quotes should use italic paragraph formatting (*"..."*) instead of blockquote
# syntax (> "...") to ensure they render with the full-contrast paragraph text color.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

echo "Checking markdown files for low-contrast blockquote patterns..."
echo "================================================================"
echo ""

EXIT_CODE=0
FILES_CHECKED=0
FILES_PASSED=0

# Grep pattern: lines starting with "> " followed by a quotation mark (decorative quote blockquotes).
# Matches ASCII double-quote ("), Unicode left double quotation mark (U+201C), and
# Unicode right double quotation mark (U+201D).
# These blockquotes render with GitHub's muted text color which fails WCAG 2 AA contrast requirements.
BLOCKQUOTE_QUOTE_PATTERN='^>\s*[\x22\x{201C}\x{201D}]'

while IFS= read -r -d '' file; do
    FILES_CHECKED=$((FILES_CHECKED + 1))

    if grep -Pq "$BLOCKQUOTE_QUOTE_PATTERN" "$file" 2>/dev/null; then
        echo "❌ $file"
        echo "   Contains a blockquote decorative quote that may fail WCAG 2 AA color contrast."
        echo "   Replace '> \"...\"' with '*\"...\"*' (italic paragraph) to use full-contrast text."
        grep -Pn "$BLOCKQUOTE_QUOTE_PATTERN" "$file" | while IFS= read -r line; do
            echo "   Line: $line"
        done
        EXIT_CODE=1
    else
        echo "✅ $file"
        FILES_PASSED=$((FILES_PASSED + 1))
    fi
done < <(find . -path '*/.git' -prune -o -name "*.md" -type f -print0)

echo ""
echo "================================================================"
echo "Summary: $FILES_PASSED/$FILES_CHECKED files pass color-contrast blockquote check"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ No low-contrast decorative blockquote patterns found"
else
    echo "❌ Low-contrast decorative blockquote patterns found"
    echo ""
    echo "To fix: Replace '> \"quote text\"' with '*\"quote text\"*'"
    echo "Example:"
    echo "  Before: > \"Your quote here.\""
    echo "  After:  *\"Your quote here.\"*"
    echo ""
    echo "This ensures the text renders with the standard high-contrast paragraph color"
    echo "and meets WCAG 2 AA minimum contrast ratio of 4.5:1."
fi

exit $EXIT_CODE

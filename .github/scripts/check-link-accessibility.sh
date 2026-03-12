#!/bin/bash
# Script to check that markdown links are accessible and distinguishable
# This helps prevent WCAG 2.1 violations related to link color contrast and
# distinguishability (axe rule: link-in-text-block)
#
# Checks:
# 1. Links use proper markdown syntax with descriptive text [text](url)
# 2. Links do not use non-descriptive generic text ("here", "click here", etc.)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "Checking markdown files for accessible link text..."
echo "=================================================="

EXIT_CODE=0
CHECKED=0
ISSUES=0

while IFS= read -r -d '' file; do
    CHECKED=$((CHECKED + 1))
    REL_PATH="${file#$REPO_ROOT/}"
    FILE_ISSUES=0

    # Check for non-descriptive link text (case-insensitive)
    while IFS= read -r line_content; do
        # Extract all markdown link texts [text](url) using grep
        while IFS= read -r link_match; do
            # Check if link text is non-descriptive
            if echo "$link_match" | grep -qiE "^\[(here|click here|read more|learn more|more|link|this)\]\("; then
                echo "❌ Non-descriptive link text in: $REL_PATH"
                echo "   Found: $link_match"
                echo "   Use descriptive link text that conveys the purpose of the link."
                FILE_ISSUES=$((FILE_ISSUES + 1))
                ISSUES=$((ISSUES + 1))
                EXIT_CODE=1
            fi
        done < <(grep -oE '\[[^]]+\]\([^)]+\)' <<< "$line_content" || true)
    done < "$file"

    if [ "$FILE_ISSUES" -eq 0 ]; then
        echo "✅ Links accessible: $REL_PATH"
    fi
done < <(find "$REPO_ROOT" -name "*.md" -type f ! -path "*/\.git/*" ! -path "*/node_modules/*" -print0)

echo ""
echo "=================================================="
echo "Results: Checked $CHECKED files, found $ISSUES link accessibility issue(s)"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All markdown links use descriptive text!"
else
    echo "❌ Some markdown links have accessibility issues."
    echo ""
    echo "To fix: Use descriptive link text that conveys the link's purpose."
    echo "Example: Instead of [here](url), use [Assignment 1C Instructions](url)"
    echo ""
    echo "WCAG 2.1 Success Criterion 2.4.4: Link Purpose (In Context)"
    echo "See: https://www.w3.org/WAI/WCAG21/Understanding/link-purpose-in-context"
fi

exit $EXIT_CODE

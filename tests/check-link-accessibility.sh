#!/bin/bash
# Test script to check markdown links for accessibility compliance
# Validates that links in text blocks have descriptive text per WCAG 2.1 link-in-text-block rule.
# See: https://dequeuniversity.com/rules/axe/4.11/link-in-text-block

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

echo "Checking markdown files for link accessibility issues..."
echo "========================================================="
echo ""

EXIT_CODE=0
FILES_CHECKED=0
ISSUES_FOUND=0

while IFS= read -r -d '' file; do
    # Skip hidden directories (like .git)
    if [[ "$file" == *"/.git/"* ]]; then
        continue
    fi

    FILES_CHECKED=$((FILES_CHECKED + 1))
    FILE_ISSUES=0

    # Extract link texts from markdown links [text](url) using grep
    # Then check each link text for accessibility issues
    while IFS= read -r link_text; do
        # Skip if empty (no links found in file)
        [[ -z "$link_text" ]] && continue

        # Check for empty link text
        trimmed=$(echo "$link_text" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
        if [[ -z "$trimmed" ]]; then
            echo "❌ $file"
            echo "   Issue: Empty link text found - links must have descriptive text"
            ISSUES_FOUND=$((ISSUES_FOUND + 1))
            FILE_ISSUES=$((FILE_ISSUES + 1))
            EXIT_CODE=1
            continue
        fi

        # Check for non-descriptive link text (case-insensitive) per WCAG 2.4.4
        lower_text=$(echo "$trimmed" | tr '[:upper:]' '[:lower:]')
        if echo "$lower_text" | grep -qE "^(here|click here|link|more|read more|this|page|see here|click|go here|learn more here)$"; then
            echo "❌ $file"
            echo "   Issue: Non-descriptive link text \"$trimmed\" - links must be distinguishable"
            echo "   See: https://dequeuniversity.com/rules/axe/4.11/link-in-text-block"
            ISSUES_FOUND=$((ISSUES_FOUND + 1))
            FILE_ISSUES=$((FILE_ISSUES + 1))
            EXIT_CODE=1
        fi
    done < <(grep -oE '\[([^]]*)\]\([^)]+\)' "$file" 2>/dev/null | sed 's/^\[//;s/\]([^)]*)//' || true)

    if [[ $FILE_ISSUES -eq 0 ]]; then
        echo "✅ $file"
    fi

done < <(find . -name "*.md" -type f -print0 | grep -zv "\.git")

echo ""
echo "========================================================="
echo "Summary: Checked $FILES_CHECKED files, found $ISSUES_FOUND link accessibility issues"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All markdown links have accessible text"
else
    echo "❌ Some markdown links have accessibility issues"
    echo ""
    echo "To fix: Ensure all links have descriptive text that identifies their purpose."
    echo "Example: Use [Resume Development Guide](url) instead of [click here](url)"
fi

exit $EXIT_CODE

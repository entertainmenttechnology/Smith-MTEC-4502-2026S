#!/usr/bin/env bash
# Test script to check markdown files for link accessibility compliance
# Validates WCAG 2.1 link-in-text-block rule: links must be distinguishable
# without relying on color alone (e.g., descriptive text, not "click here").
#
# Reference: https://dequeuniversity.com/rules/axe/4.11/link-in-text-block

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

echo "Checking markdown files for link accessibility..."
echo "=================================================="
echo ""

EXIT_CODE=0
FILES_CHECKED=0
FILES_PASSED=0

# Patterns for non-descriptive link text (WCAG 2.4.4 / 2.4.9)
NON_DESCRIPTIVE_PATTERNS=(
    "^click here$"
    "^here$"
    "^read more$"
    "^more$"
    "^link$"
    "^this$"
    "^this link$"
    "^url$"
    "^this url$"
)

while IFS= read -r -d '' file; do
    FILES_CHECKED=$((FILES_CHECKED + 1))

    FILE_PASSED=true

    # Extract all markdown inline links: [text](url)
    while IFS= read -r link_text; do
        # Normalize to lowercase for pattern matching
        lower_text=$(echo "$link_text" | tr '[:upper:]' '[:lower:]')

        for pattern in "${NON_DESCRIPTIVE_PATTERNS[@]}"; do
            if echo "$lower_text" | grep -qiE "$pattern"; then
                if [ "$FILE_PASSED" = true ]; then
                    echo "❌ $file"
                fi
                echo "   Non-descriptive link text: \"$link_text\""
                echo "   Links must have meaningful text so they are distinguishable"
                echo "   without relying on color alone (WCAG 2.4.4, link-in-text-block)"
                FILE_PASSED=false
                EXIT_CODE=1
                break
            fi
        done
    done < <(grep -oP '(?<=\[)[^\]]+(?=\]\()' "$file" 2>/dev/null || true)

    if [ "$FILE_PASSED" = true ]; then
        echo "✅ $file"
        FILES_PASSED=$((FILES_PASSED + 1))
    fi
done < <(find . -name "*.md" -type f ! -path "*/.git/*" ! -path "*/.github/*" -print0)

echo ""
echo "=================================================="
echo "Summary: $FILES_PASSED/$FILES_CHECKED files have accessible links"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All markdown links use descriptive text"
else
    echo "❌ Some markdown links have non-descriptive text"
    echo ""
    echo "To fix: Replace generic link text (e.g., 'click here', 'here') with"
    echo "descriptive text that conveys the purpose of the link."
    echo "Example: Instead of [click here](url), use [View the assignment details](url)"
fi

exit $EXIT_CODE

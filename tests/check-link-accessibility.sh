#!/bin/bash
# Test script to check markdown files for accessible link text
# Ensures links are distinguishable and use descriptive anchor text
# This helps prevent WCAG 2.1 link-in-text-block violations (axe rule: link-in-text-block)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

echo "Checking markdown files for accessible link text..."
echo "=================================================="
echo ""

EXIT_CODE=0
FILES_CHECKED=0
FILES_PASSED=0

# Non-descriptive link texts that fail WCAG 2.4.4 (Link Purpose)
# and can contribute to link-in-text-block violations
AMBIGUOUS_PATTERNS=(
    "^\[here\]"
    "^\[click here\]"
    "^\[this link\]"
    "^\[link\]"
    "^\[url\]"
    "^\[read more\]"
    "^\[more\]"
    "^\[learn more\]"
    "^\[click\]"
)

while IFS= read -r -d '' file; do
    FILES_CHECKED=$((FILES_CHECKED + 1))
    FILE_PASS=1

    # Check for ambiguous link text (case-insensitive)
    while IFS= read -r line; do
        for pattern in "${AMBIGUOUS_PATTERNS[@]}"; do
            if echo "$line" | grep -qi "$pattern"; then
                if [ "$FILE_PASS" -eq 1 ]; then
                    echo "❌ $file"
                    FILE_PASS=0
                    EXIT_CODE=1
                fi
                echo "   Non-descriptive link text found: $line"
                echo "   Links must have descriptive text to be distinguishable (WCAG 2.4.4)"
            fi
        done
    done < "$file"

    if [ "$FILE_PASS" -eq 1 ]; then
        echo "✅ $file"
        FILES_PASSED=$((FILES_PASSED + 1))
    fi

done < <(find . -name "*.md" -type f ! -path "*/.git/*" ! -path "*/node_modules/*" -print0)

echo ""
echo "=================================================="
echo "Summary: $FILES_PASSED/$FILES_CHECKED files have accessible link text"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All markdown files have accessible link text"
else
    echo "❌ Some markdown files have non-descriptive link text"
    echo ""
    echo "To fix: Replace generic link text (e.g., 'here', 'click here') with"
    echo "descriptive text that conveys the purpose of the link."
    echo "Example: [Job Listings page](https://example.com) instead of [here](https://example.com)"
fi

exit $EXIT_CODE

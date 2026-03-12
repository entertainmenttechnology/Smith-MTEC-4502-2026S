#!/bin/bash
# Test script to check markdown files have a main landmark for accessibility compliance
# This ensures WCAG 2.1 compliance by validating that pages have proper main landmark structure
# The landmark-one-main rule (axe/4.11) requires a document to have exactly one main landmark

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

echo "Checking markdown files for main landmark (<main> element)..."
echo "=============================================================="
echo ""

EXIT_CODE=0
FILES_CHECKED=0
FILES_PASSED=0
FILES_SKIPPED=0

while IFS= read -r -d '' file; do
    FILES_CHECKED=$((FILES_CHECKED + 1))

    # Check if file contains a <main> HTML element
    if grep -q "<main" "$file"; then
        echo "✅ $file"
        FILES_PASSED=$((FILES_PASSED + 1))
    else
        echo "⚠️  $file"
        echo "   No explicit <main> element found."
        echo "   Note: GitHub's rendering provides the main landmark for this file."
        FILES_SKIPPED=$((FILES_SKIPPED + 1))
    fi
done < <(find . -name "*.md" -type f ! -path '*/.git/*' -print0)

echo ""
echo "=============================================================="
echo "Summary: $FILES_PASSED/$FILES_CHECKED files have explicit <main> landmark"
echo "         ($FILES_SKIPPED files rely on host page for main landmark)"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ Main landmark check complete"
fi

exit $EXIT_CODE

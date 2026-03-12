#!/bin/bash
# Test script to check markdown files have landmark-compliant structure
# Ensures content is contained within heading sections as required by WCAG 2.1
# Addresses the axe 'region' rule: all page content must be contained by landmarks
# Reference: https://dequeuniversity.com/rules/axe/4.11/region

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

echo "Checking markdown files for landmark-compliant structure (axe region rule)..."
echo "=============================================================================="
echo ""

EXIT_CODE=0
FILES_CHECKED=0
FILES_PASSED=0

while IFS= read -r -d '' file; do
    FILES_CHECKED=$((FILES_CHECKED + 1))

    # Check if there is any non-empty content before the first heading.
    # Content that appears before the first heading is not contained by any
    # landmark section, which triggers the axe 'region' accessibility violation.
    # Strip HTML comments (single-line and multi-line) before finding first content.
    first_line=$(sed 's/<!--.*-->//g' "$file" | sed '/<!--/,/-->/d' | grep -v '^[[:space:]]*$' | head -1)

    if [[ "$first_line" =~ ^#+[[:space:]]+ ]]; then
        echo "✅ $file"
        FILES_PASSED=$((FILES_PASSED + 1))
    else
        echo "❌ $file"
        echo "   First non-empty line is not a heading: ${first_line:0:80}"
        echo "   Content before the first heading is outside landmark regions"
        EXIT_CODE=1
    fi
done < <(find . -name "*.md" -type f -not -path "*/.git/*" -print0)

echo ""
echo "=============================================================================="
echo "Summary: $FILES_PASSED/$FILES_CHECKED files have landmark-compliant structure"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All markdown files have landmark-compliant structure"
else
    echo "❌ Some markdown files have content outside landmark regions"
    echo ""
    echo "To fix: Ensure the first non-empty line is a heading (e.g., '# Title')"
    echo "Content before the first heading is not contained by any landmark region."
    echo "This violates WCAG 2.1 and the axe 'region' accessibility rule."
fi

exit $EXIT_CODE

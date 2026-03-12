#!/bin/bash
# Test script to check markdown files have proper landmark region structure
# This ensures WCAG 2.1 compliance with the axe 'region' rule:
#   "All page content should be contained by landmarks"
#
# For markdown files, landmark compliance requires:
#   1. The first non-empty content line must be a level-one heading (# Title)
#   2. All subsequent content must be organized under headings
#
# When markdown is rendered to HTML by GitHub, the content is placed inside
# GitHub's <main> landmark. A proper H1 heading ensures the page title is
# within the landmark structure and helps prevent the axe 'region' violation.
#
# Reference: https://dequeuniversity.com/rules/axe/4.11/region

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

echo "Checking markdown files for landmark region compliance (axe: region rule)..."
echo "============================================================================"
echo ""

EXIT_CODE=0
FILES_CHECKED=0
FILES_PASSED=0

while IFS= read -r -d '' file; do
    # Skip hidden directories (like .git)
    if [[ "$file" == *"/.git/"* ]]; then
        continue
    fi

    FILES_CHECKED=$((FILES_CHECKED + 1))

    # Get the first non-empty line that is not an HTML comment block opener.
    # Strips blank lines and lines beginning with <!-- (block-level front-matter
    # comments such as <!-- markdownlint-disable ... -->) before checking.
    first_content=$(grep -v '^[[:space:]]*$' "$file" | grep -v '^[[:space:]]*<!--' | head -1)

    # The first non-empty content line must be a valid level-one heading (# followed by a space and title text)
    if [[ "$first_content" =~ ^#[[:space:]] ]]; then
        echo "✅ $file"
        FILES_PASSED=$((FILES_PASSED + 1))
    else
        echo "❌ $file"
        echo "   First non-empty content line: ${first_content:0:80}"
        echo "   Expected: A level-one heading starting with '# '"
        echo "   Fix: Ensure all content is under a level-one heading for landmark compliance"
        EXIT_CODE=1
    fi
done < <(find . -name "*.md" -type f -print0 | grep -zv '/.git/')

echo ""
echo "============================================================================"
echo "Summary: $FILES_PASSED/$FILES_CHECKED files pass landmark region compliance"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All markdown files comply with the axe 'region' rule"
else
    echo "❌ Some markdown files may violate the axe 'region' rule"
    echo ""
    echo "To fix:"
    echo "  - Ensure the first non-empty line of each file is a level-one heading"
    echo "  - Example: # Page Title"
    echo "  - This ensures all content is within landmark regions when rendered"
    echo ""
    echo "Reference: https://dequeuniversity.com/rules/axe/4.11/region"
fi

exit $EXIT_CODE

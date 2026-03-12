#!/bin/bash
# Test script to check that markdown files satisfy the axe 'region' landmark rule.
# WCAG 2.1 requires all significant page content to be contained within landmark regions.
# For GitHub-rendered markdown pages, this is satisfied when:
#   - The file starts with a level-one heading (# ) as its first non-empty content
#   - No significant content appears before the primary heading landmark anchor
# This prevents accessibility violations where content floats outside landmark regions.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

echo "Checking markdown files for landmark/region accessibility compliance..."
echo "========================================================================"
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

    # Find the first non-empty, non-comment line
    # HTML comments (<!-- ... -->) are not rendered content and should be excluded
    # Use sed to strip HTML comments (including multi-line) before finding first content line
    first_content_line=$(sed '/<!--/,/-->/d' "$file" | grep -v '^[[:space:]]*$' | head -1)

    if [[ "$first_content_line" =~ ^#[[:space:]]+ ]]; then
        echo "✅ $file"
        FILES_PASSED=$((FILES_PASSED + 1))
    else
        echo "❌ $file"
        echo "   First rendered content line: ${first_content_line:0:80}"
        echo "   Issue: Content appears before a landmark heading, violating the axe 'region' rule."
        echo "   Fix: Ensure the file starts with a level-one heading ('# Title') before any"
        echo "        other rendered content. HTML comments (<!-- -->) are allowed before headings."
        EXIT_CODE=1
    fi
done < <(find . -name "*.md" -type f -print0 | grep -zv ".git")

echo ""
echo "========================================================================"
echo "Summary: $FILES_PASSED/$FILES_CHECKED files pass landmark accessibility check"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All markdown files have a level-one heading as first rendered content"
else
    echo "❌ Some markdown files have content before the first heading"
    echo ""
    echo "To fix: Move any non-heading content (except HTML comments) to after the"
    echo "first level-one heading (# Title) in each failing file."
    echo ""
    echo "Why this matters:"
    echo "  GitHub renders markdown pages with its own <main> landmark wrapper."
    echo "  However, having proper heading structure ensures the axe 'region' rule"
    echo "  (https://dequeuniversity.com/rules/axe/4.11/region) is not violated."
fi

exit $EXIT_CODE

#!/bin/bash
# Script to check that all markdown files have exactly one level-one heading (#)
# and do not contain duplicate <main> HTML elements.
# This helps ensure WCAG 2.1 landmark-one-main compliance:
#   - Each document must have a single primary content section (mapped from the H1)
#   - No conflicting <main> HTML elements that would break the rendered page structure.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "Checking markdown files for landmark-main accessibility compliance..."
echo "======================================================================"

EXIT_CODE=0
CHECKED=0
ISSUES=0

# Find all markdown files (excluding .git, .github internal scripts, and node_modules)
# .github/ files are CI/CD configuration and meta-documentation, not accessible course content
while IFS= read -r -d '' file; do
    CHECKED=$((CHECKED + 1))
    REL_PATH="${file#$REPO_ROOT/}"
    FILE_OK=true

    # Count level-one headings in the file
    H1_COUNT=$(grep -c "^# " "$file" || true)

    if [ "$H1_COUNT" -eq 0 ]; then
        echo "❌ Missing H1 (no main landmark): $REL_PATH"
        FILE_OK=false
        ISSUES=$((ISSUES + 1))
        EXIT_CODE=1
    elif [ "$H1_COUNT" -gt 1 ]; then
        echo "❌ Multiple H1 headings (ambiguous main landmark): $REL_PATH ($H1_COUNT found)"
        FILE_OK=false
        ISSUES=$((ISSUES + 1))
        EXIT_CODE=1
    fi

    # Check for conflicting <main> HTML elements in markdown content
    # A <main> element in a markdown file conflicts with the rendered page template
    MAIN_TAG_COUNT=$(grep -c -i "<main" "$file" || true)
    if [ "$MAIN_TAG_COUNT" -gt 0 ]; then
        echo "❌ Conflicting <main> HTML element found: $REL_PATH"
        FILE_OK=false
        ISSUES=$((ISSUES + 1))
        EXIT_CODE=1
    fi

    if [ "$FILE_OK" = true ]; then
        echo "✅ Landmark-main OK: $REL_PATH"
    fi
done < <(find "$REPO_ROOT" -name "*.md" -type f ! -path "*/\.git/*" ! -path "*/\.github/*" ! -path "*/node_modules/*" -print0)

echo ""
echo "======================================================================"
echo "Results: Checked $CHECKED files, $ISSUES landmark-main issues found"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All markdown files meet landmark-main accessibility requirements!"
else
    echo "❌ Some markdown files have landmark-main accessibility issues."
    echo ""
    echo "To fix missing H1: Add a single level-one heading (e.g., '# Title') near the top."
    echo "To fix multiple H1: Ensure only one '# Heading' exists per file."
    echo "To fix <main> conflict: Remove any inline <main> HTML tags from the markdown."
    echo ""
    echo "These checks help satisfy WCAG 2.1 / axe landmark-one-main rule."
fi

exit $EXIT_CODE

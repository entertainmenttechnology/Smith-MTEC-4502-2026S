#!/bin/bash
# Script to check that all markdown files have a lang attribute in YAML front matter
# This helps prevent accessibility issues where rendered HTML lacks a lang attribute on <html>
# (WCAG 2.1 / axe rule: html-has-lang)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "Checking markdown files for lang attribute in YAML front matter..."
echo "=================================================================="

EXIT_CODE=0
CHECKED=0
MISSING=0

# Find all markdown files (excluding .git directory and node_modules)
while IFS= read -r -d '' file; do
    CHECKED=$((CHECKED + 1))
    REL_PATH="${file#$REPO_ROOT/}"

    # Check if file starts with YAML front matter containing a lang attribute
    # Front matter is delimited by --- at start, and lang: must appear within the first 5 lines
    first_lines=$(head -5 "$file")

    if echo "$first_lines" | grep -q "^---" && echo "$first_lines" | grep -q "^lang:"; then
        echo "✅ Has lang: $REL_PATH"
    else
        echo "❌ Missing lang: $REL_PATH"
        MISSING=$((MISSING + 1))
        EXIT_CODE=1
    fi
done < <(find "$REPO_ROOT" -name "*.md" -type f ! -path "*/\.git/*" ! -path "*/node_modules/*" -print0)

echo ""
echo "=================================================================="
echo "Results: Checked $CHECKED files, $MISSING missing lang attribute"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All markdown files have a lang attribute in YAML front matter!"
else
    echo "❌ Some markdown files are missing a lang attribute in YAML front matter."
    echo ""
    echo "To fix: Add YAML front matter with 'lang: en' at the top of each file:"
    echo "  ---"
    echo "  lang: en"
    echo "  ---"
    echo ""
    echo "This is required for WCAG 2.1 accessibility compliance (html-has-lang rule)."
fi

exit $EXIT_CODE

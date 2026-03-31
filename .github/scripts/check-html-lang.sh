#!/bin/bash
# Script to check that all HTML files have a lang attribute on the <html> element
# This ensures WCAG 2.1 compliance (html-has-lang rule) for any HTML files in the repo

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "Checking HTML files for lang attribute..."
echo "========================================="

EXIT_CODE=0
CHECKED=0
MISSING=0

# Find all HTML files (excluding .git directory and node_modules)
while IFS= read -r -d '' file; do
    CHECKED=$((CHECKED + 1))
    REL_PATH="${file#$REPO_ROOT/}"

    # Check if <html> tag has a lang attribute with a non-empty value
    if grep -qiP '<html[^>]*lang=['"'"'"][^'"'"'"]+['"'"'"]' "$file"; then
        echo "✅ Has lang: $REL_PATH"
    else
        echo "❌ Missing lang on <html>: $REL_PATH"
        MISSING=$((MISSING + 1))
        EXIT_CODE=1
    fi
done < <(find "$REPO_ROOT" -name "*.html" -type f ! -path "*/\.git/*" ! -path "*/node_modules/*" -print0)

echo ""
echo "========================================="
if [ "$CHECKED" -eq 0 ]; then
    echo "✅ No HTML files found — nothing to check."
else
    echo "Results: Checked $CHECKED files, $MISSING missing lang attribute"
    if [ $EXIT_CODE -eq 0 ]; then
        echo "✅ All HTML files have a lang attribute on <html>!"
    else
        echo "❌ Some HTML files are missing a lang attribute on <html>."
        echo ""
        echo "To fix: Add a lang attribute to the <html> element, e.g.:"
        echo "  <html lang=\"en\">"
        echo "This is required for WCAG 2.1 accessibility compliance."
    fi
fi

exit $EXIT_CODE

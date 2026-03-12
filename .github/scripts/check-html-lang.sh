#!/bin/bash
# Script to check that all HTML files have a lang attribute on the <html> element
# This ensures WCAG 2.1 compliance (html-has-lang rule) and proper language identification
# for assistive technologies.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "Checking HTML files for lang attribute on <html> element..."
echo "============================================================"

EXIT_CODE=0
CHECKED=0
MISSING=0

# Find all HTML files (excluding .git directory and node_modules)
while IFS= read -r -d '' file; do
    CHECKED=$((CHECKED + 1))
    REL_PATH="${file#$REPO_ROOT/}"

    # Check if file contains an <html> element with a lang attribute
    # Matches patterns like: <html lang="en">, <html lang='en'>, <HTML LANG="en">, etc.
    if grep -qi '<html[^>]*\slang=' "$file"; then
        echo "✅ Has lang attribute: $REL_PATH"
    else
        echo "❌ Missing lang attribute on <html>: $REL_PATH"
        MISSING=$((MISSING + 1))
        EXIT_CODE=1
    fi
done < <(find "$REPO_ROOT" -name "*.html" -type f ! -path "*/.git/*" ! -path "*/node_modules/*" -print0)

echo ""
echo "============================================================"
echo "Results: Checked $CHECKED HTML files, $MISSING missing lang attribute"

if [ $CHECKED -eq 0 ]; then
    echo "✅ No HTML files found — nothing to check."
elif [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All HTML files have a lang attribute on <html>!"
else
    echo "❌ Some HTML files are missing a lang attribute on <html>."
    echo ""
    echo "To fix: Add a lang attribute to the <html> element, e.g.:"
    echo '  <html lang="en">'
    echo ""
    echo "This is required for WCAG 2.1 Success Criterion 3.1.1 (Language of Page)"
    echo "and prevents axe rule html-has-lang violations."
fi

exit $EXIT_CODE

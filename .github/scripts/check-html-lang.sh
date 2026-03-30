#!/bin/bash
# Script to check that all HTML files have a lang attribute on the <html> element
# This prevents the WCAG 2.1 / axe html-has-lang accessibility violation.
#
# Reference: https://dequeuniversity.com/rules/axe/4.11/html-has-lang

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "Checking HTML files for lang attribute on <html> element..."
echo "============================================================"

EXIT_CODE=0
CHECKED=0
MISSING=0

# Find all HTML files (excluding .git and node_modules)
while IFS= read -r -d '' file; do
    CHECKED=$((CHECKED + 1))
    REL_PATH="${file#$REPO_ROOT/}"

    # Check if <html> element has a lang attribute
    # Matches: <html lang="en">, <html lang='fr'>, <HTML LANG="en">, etc.
    if grep -qi '<html[^>]*lang[[:space:]]*=' "$file"; then
        echo "✅ Has lang: $REL_PATH"
    else
        echo "❌ Missing lang on <html>: $REL_PATH"
        MISSING=$((MISSING + 1))
        EXIT_CODE=1
    fi
done < <(find "$REPO_ROOT" -name "*.html" -type f ! -path "*/\.git/*" ! -path "*/node_modules/*" -print0)

echo ""
echo "============================================================"

if [ "$CHECKED" -eq 0 ]; then
    echo "✅ No HTML files found — nothing to check"
    exit 0
fi

echo "Results: Checked $CHECKED files, $MISSING missing lang attribute on <html>"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All HTML files have a lang attribute on the <html> element!"
else
    echo "❌ Some HTML files are missing a lang attribute on the <html> element."
    echo ""
    echo "To fix: Add lang=\"en\" (or appropriate language code) to the <html> element."
    echo "Example: <html lang=\"en\">"
    echo ""
    echo "Reference: https://dequeuniversity.com/rules/axe/4.11/html-has-lang"
fi

exit $EXIT_CODE

#!/bin/bash
# Test script to check HTML files have a lang attribute on the <html> element
# This ensures WCAG 2.1 compliance (html-has-lang rule) by validating that
# every HTML document declares a language attribute.
#
# Reference: https://dequeuniversity.com/rules/axe/4.11/html-has-lang

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

echo "Checking HTML files for lang attribute on <html> element..."
echo "============================================================"
echo ""

EXIT_CODE=0
FILES_CHECKED=0
FILES_PASSED=0

while IFS= read -r -d '' file; do
    FILES_CHECKED=$((FILES_CHECKED + 1))

    # Check if the file contains an <html> element with a lang attribute
    # Matches patterns like: <html lang="en">, <html lang='en'>, <HTML LANG="en">, etc.
    if grep -qi '<html[^>]*lang[[:space:]]*=' "$file"; then
        echo "✅ $file"
        FILES_PASSED=$((FILES_PASSED + 1))
    else
        echo "❌ $file"
        echo "   The <html> element is missing a lang attribute"
        echo "   Expected: <html lang=\"en\"> (or appropriate language code)"
        EXIT_CODE=1
    fi
done < <(find . -name "*.html" -type f ! -path "*/\.git/*" ! -path "*/node_modules/*" -print0)

echo ""
echo "============================================================"

if [ "$FILES_CHECKED" -eq 0 ]; then
    echo "✅ No HTML files found — nothing to check"
    exit 0
fi

echo "Summary: $FILES_PASSED/$FILES_CHECKED HTML files have a lang attribute on <html>"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All HTML files have a lang attribute on the <html> element"
else
    echo "❌ Some HTML files are missing a lang attribute on the <html> element"
    echo ""
    echo "To fix: Add a lang attribute to the <html> element in each flagged file"
    echo "Example: <html lang=\"en\">"
    echo ""
    echo "Reference: https://dequeuniversity.com/rules/axe/4.11/html-has-lang"
fi

exit $EXIT_CODE

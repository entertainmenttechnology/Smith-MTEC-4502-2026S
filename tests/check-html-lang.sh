#!/bin/bash
# Test script to check HTML files have a lang attribute on the <html> element
# This ensures WCAG 2.1 / WCAG 3.1.1 compliance (html-has-lang rule) so that
# the default human language of each page can be programmatically determined.

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
    # Skip hidden directories (like .git)
    if [[ "$file" == *"/.git/"* ]]; then
        continue
    fi

    FILES_CHECKED=$((FILES_CHECKED + 1))

    # Check if the first 10 lines contain an <html> element with a lang attribute.
    # The <html> tag always appears near the top of a valid HTML document.
    # Using head -10 avoids false positives from lang= appearing in body content.
    # Matches patterns like: <html lang="en">, <html lang='en'>, <html lang=en>, etc.
    if head -10 "$file" | grep -qi '<html[^>]*lang='; then
        echo "✅ $file"
        FILES_PASSED=$((FILES_PASSED + 1))
    else
        echo "❌ $file"
        echo "   Missing lang attribute on <html> element"
        echo "   Expected: <html lang=\"en\"> (or appropriate language code)"
        EXIT_CODE=1
    fi
done < <(find . -name "*.html" -type f -print0)

echo ""
echo "============================================================"

if [ $FILES_CHECKED -eq 0 ]; then
    echo "✅ No HTML files found — nothing to check"
    echo "   (If HTML files are added in the future, they must include lang on <html>)"
    exit 0
fi

echo "Summary: $FILES_PASSED/$FILES_CHECKED HTML files have a lang attribute on <html>"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All HTML files have a lang attribute on the <html> element"
else
    echo "❌ Some HTML files are missing a lang attribute on the <html> element"
    echo ""
    echo "To fix: Add a lang attribute to the opening <html> tag, e.g.:"
    echo "  <html lang=\"en\">"
    echo ""
    echo "See: https://dequeuniversity.com/rules/axe/4.11/html-has-lang"
fi

exit $EXIT_CODE

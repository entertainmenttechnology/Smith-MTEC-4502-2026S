#!/bin/bash
# Test script to check HTML files have a lang attribute on the <html> element
# This ensures WCAG 2.1 compliance (html-has-lang rule) and prevents axe violations

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

    # Check if file has <html with a lang attribute (e.g., <html lang="en"> or <html lang='en'>)
    if grep -qi '<html[^>]* lang=' "$file"; then
        echo "✅ $file"
        FILES_PASSED=$((FILES_PASSED + 1))
    else
        echo "❌ $file"
        echo "   Missing lang attribute on <html> element"
        echo "   Expected: <html lang=\"en\"> (or appropriate language code)"
        EXIT_CODE=1
    fi
done < <(find . \( -name "*.html" -o -name "*.htm" \) -type f -print0 | grep -zv "\.git")

echo ""
echo "============================================================"

if [ "$FILES_CHECKED" -eq 0 ]; then
    echo "✅ No HTML files found — nothing to check."
    exit 0
fi

echo "Summary: $FILES_PASSED/$FILES_CHECKED HTML files have a lang attribute on <html>"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All HTML files have a lang attribute on <html>"
else
    echo "❌ Some HTML files are missing a lang attribute on <html>"
    echo ""
    echo "To fix: Add a lang attribute to the <html> element"
    echo "Example: <html lang=\"en\">"
fi

exit $EXIT_CODE

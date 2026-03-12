#!/bin/bash
# Test script to verify HTML files in the repository have a lang attribute on <html>
# This ensures WCAG 2.1 compliance with the html-has-lang rule:
#   https://dequeuniversity.com/rules/axe/4.11/html-has-lang

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "Testing HTML files for lang attribute compliance..."
echo "==================================================="
echo ""

EXIT_CODE=0
FILES_CHECKED=0
FILES_PASSED=0

while IFS= read -r -d '' file; do
    FILES_CHECKED=$((FILES_CHECKED + 1))
    REL_PATH="${file#$REPO_ROOT/}"

    if grep -qiP '<html[^>]*lang=['"'"'"][^'"'"'"]+['"'"'"]' "$file"; then
        echo "✅ $REL_PATH"
        FILES_PASSED=$((FILES_PASSED + 1))
    else
        echo "❌ $REL_PATH"
        echo "   The <html> element is missing a lang attribute"
        echo "   Fix: change to <html lang=\"en\"> (or the appropriate language code)"
        EXIT_CODE=1
    fi
done < <(find "$REPO_ROOT" -name "*.html" -type f ! -path "*/\.git/*" ! -path "*/node_modules/*" -print0)

echo ""
echo "==================================================="

if [ "$FILES_CHECKED" -eq 0 ]; then
    echo "✅ No HTML files found — html-has-lang check passes (nothing to fail)."
    exit 0
fi

echo "Summary: $FILES_PASSED/$FILES_CHECKED HTML files have a lang attribute on <html>"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All HTML files meet WCAG 2.1 html-has-lang requirement"
else
    echo "❌ Some HTML files are missing a lang attribute on <html>"
    echo ""
    echo "To fix: Add lang=\"en\" (or another BCP 47 language tag) to the <html> element"
    echo "Example: <html lang=\"en\">"
fi

exit $EXIT_CODE

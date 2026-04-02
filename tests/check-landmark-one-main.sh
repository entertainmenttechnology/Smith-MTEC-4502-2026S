#!/bin/bash
# Test script to verify WCAG 2.1 landmark-one-main accessibility compliance
# Ensures markdown files do not embed duplicate <main> HTML elements, which would
# cause a violation when rendered by GitHub (which already provides one <main> landmark).
#
# Rule: landmark-one-main (axe-core)
# Reference: https://dequeuniversity.com/rules/axe/4.11/landmark-one-main

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

echo "Checking landmark-one-main accessibility compliance..."
echo "======================================================="
echo ""
echo "GitHub renders each markdown file inside its own <main> landmark."
echo "Embedding additional <main> elements in markdown content would create"
echo "duplicate landmarks, violating WCAG 2.1 landmark-one-main requirement."
echo ""

EXIT_CODE=0
FILES_CHECKED=0
FILES_PASSED=0

# Use Python3 to strip code blocks before checking for <main> tags.
# This prevents false positives from code examples in documentation.
check_file_for_main() {
    local file="$1"
    python3 - "$file" <<'PYEOF'
import sys
import re

filepath = sys.argv[1]
with open(filepath, 'r', encoding='utf-8', errors='replace') as f:
    content = f.read()

# Remove fenced code blocks (``` or ~~~)
content = re.sub(r'```[\s\S]*?```', '', content)
content = re.sub(r'~~~[\s\S]*?~~~', '', content)

# Remove inline code (`...`)
content = re.sub(r'`[^`\n]*`', '', content)

# Check for <main> elements or role="main" attributes outside code blocks
pattern = re.compile(r'<main\b|role=["\']main["\']', re.IGNORECASE)
matches = pattern.findall(content)

if matches:
    print(len(matches))
else:
    print(0)
PYEOF
}

while IFS= read -r -d '' file; do
    # Skip hidden directories (like .git)
    if [[ "$file" == *"/.git/"* ]]; then
        continue
    fi

    FILES_CHECKED=$((FILES_CHECKED + 1))

    MAIN_COUNT=$(check_file_for_main "$file")

    if [ "$MAIN_COUNT" -gt 0 ]; then
        echo "❌ $file"
        echo "   Found $MAIN_COUNT embedded main landmark(s) outside code blocks."
        echo "   Remove <main> tags and role=\"main\" attributes from the markdown."
        echo "   GitHub's rendering already provides one <main> landmark for the page."
        EXIT_CODE=1
    else
        echo "✅ $file"
        FILES_PASSED=$((FILES_PASSED + 1))
    fi
done < <(find . -name "*.md" -type f -print0)

echo ""
echo "======================================================="
echo "Summary: $FILES_PASSED/$FILES_CHECKED files pass the landmark-one-main check"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All markdown files pass landmark-one-main compliance"
    echo "   GitHub's rendering provides exactly one <main> landmark per page."
else
    echo "❌ Some markdown files fail the landmark-one-main check"
    echo ""
    echo "To fix: Remove any <main> HTML elements or role=\"main\" attributes"
    echo "from markdown content (outside of code blocks)."
    echo "GitHub provides the <main> landmark automatically."
fi

exit $EXIT_CODE

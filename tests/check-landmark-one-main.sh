#!/bin/bash
# Test script to check markdown files comply with the landmark-one-main accessibility rule
# WCAG 2.1 requires documents to have exactly one <main> landmark element.
#
# For markdown files rendered on GitHub.com, GitHub provides one <main> element
# from its page template. If a markdown file also contains inline HTML <main>
# elements, the rendered page will have multiple <main> landmarks, violating
# the axe rule: landmark-one-main.
#
# This script ensures no markdown file introduces extra <main> elements via
# inline HTML, which would produce duplicate main landmarks on the GitHub page.
# Content inside fenced code blocks (```) and inline code (`) is excluded
# because GitHub's renderer displays it as preformatted text, not HTML.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

echo "Checking markdown files for duplicate <main> landmark elements..."
echo "=================================================================="
echo ""

EXIT_CODE=0
FILES_CHECKED=0
FILES_PASSED=0

while IFS= read -r -d '' file; do
    FILES_CHECKED=$((FILES_CHECKED + 1))

    # Use Python to check for <main> elements outside of code blocks.
    # Content inside fenced (```) or inline (`) code blocks is excluded
    # because GitHub's Markdown renderer does not interpret it as HTML.
    MAIN_COUNT=$(python3 - "$file" <<'PYEOF'
import sys, re

file_path = sys.argv[1]
with open(file_path, 'r', encoding='utf-8', errors='replace') as f:
    content = f.read()

# Remove fenced code blocks (``` optionally followed by a language identifier)
content = re.sub(r'```[^\n]*\n.*?```', '', content, flags=re.DOTALL)
# Remove inline code spans (` ... `), handling single-backtick spans only
content = re.sub(r'`[^`\n]+`', '', content)

# Count remaining <main occurrences (case-insensitive)
count = len(re.findall(r'<main', content, re.IGNORECASE))
print(count)
PYEOF
)

    MAIN_COUNT="${MAIN_COUNT:-0}"

    if [ "${MAIN_COUNT}" -gt 0 ] 2>/dev/null; then
        echo "❌ $file"
        echo "   Found $MAIN_COUNT inline <main> element(s) outside code blocks."
        echo "   Remove them to prevent duplicate main landmarks on GitHub-rendered pages."
        EXIT_CODE=1
    else
        echo "✅ $file"
        FILES_PASSED=$((FILES_PASSED + 1))
    fi
done < <(find . -name "*.md" -type f -print0 | grep -zv ".git")

echo ""
echo "=================================================================="
echo "Summary: $FILES_PASSED/$FILES_CHECKED files pass the landmark-one-main check"
echo ""

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All markdown files comply with landmark-one-main rule"
    echo "   (No inline <main> elements found outside code blocks;"
    echo "    GitHub provides exactly one <main> landmark per page from its page template.)"
else
    echo "❌ Some markdown files contain inline <main> HTML elements"
    echo ""
    echo "To fix: Remove any '<main>' HTML tags from the affected markdown files."
    echo "GitHub's page template already provides a <main> landmark; adding another"
    echo "violates the WCAG 2.1 landmark-one-main rule (axe rule ID: landmark-one-main)."
    echo "See: https://dequeuniversity.com/rules/axe/4.11/landmark-one-main"
fi

exit $EXIT_CODE

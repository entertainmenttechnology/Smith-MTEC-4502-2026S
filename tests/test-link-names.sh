#!/bin/bash
# Test script to check markdown links have discernible text for accessibility compliance
# Ensures WCAG 2.1 / axe link-name rule: links must have discernible text
# See: https://dequeuniversity.com/rules/axe/4.11/link-name

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

echo "Checking markdown files for links with discernible text..."
echo "==========================================================="
echo ""

EXIT_CODE=0
FILES_CHECKED=0
FILES_PASSED=0

while IFS= read -r -d '' file; do
    FILES_CHECKED=$((FILES_CHECKED + 1))
    FILE_PASS=true

    # Find markdown links with empty or whitespace-only text: [](...) or [ ](...)
    # Skip content inside inline code spans (backtick-quoted)
    while IFS= read -r line_info; do
        lineno="${line_info%%:*}"
        line="${line_info#*:}"
        # Skip lines where the empty link is inside an inline code span
        if echo "$line" | grep -qP '`[^`]*\[\s*\]\([^)]*\)[^`]*`'; then
            continue
        fi
        echo "❌ $file (line $lineno): Link missing discernible text: $line"
        FILE_PASS=false
        EXIT_CODE=1
    done < <(grep -nP '\[\s*\]\([^)]*\)' "$file" 2>/dev/null || true)

    if $FILE_PASS; then
        echo "✅ $file"
        FILES_PASSED=$((FILES_PASSED + 1))
    fi
done < <(find . -name "*.md" -type f -print0 | grep -zv ".git")

echo ""
echo "==========================================================="
echo "Summary: $FILES_PASSED/$FILES_CHECKED files have all links with discernible text"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All markdown links have discernible text"
else
    echo "❌ Some markdown links are missing discernible text"
    echo ""
    echo "To fix: Ensure every link has visible text between [ and ]"
    echo "Example: [Visit WCAG Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)"
fi

exit $EXIT_CODE

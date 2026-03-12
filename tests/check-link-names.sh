#!/bin/bash
# Test script to check markdown files for links with discernible text
# This ensures WCAG 2.1 compliance by validating that all links have accessible names
# Addresses axe rule: link-name (https://dequeuniversity.com/rules/axe/4.11/link-name)

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
TOTAL_VIOLATIONS=0

while IFS= read -r -d '' file; do
    # Skip hidden directories (like .git)
    if [[ "$file" == *"/.git/"* ]]; then
        continue
    fi

    FILES_CHECKED=$((FILES_CHECKED + 1))
    FILE_VIOLATIONS=0

    # Check for markdown links with empty text: [](...) or [][]
    # Matches [] followed by ( (inline link) or [ (reference link), but not ![]() image syntax
    # Uses awk to strip inline code spans (backtick-delimited) before checking to avoid false positives
    while IFS= read -r line_info; do
        line_num="${line_info%%:*}"
        line_content="${line_info#*:}"
        echo "❌ $file (line $line_num): Link with empty text found"
        echo "   Content: ${line_content:0:120}"
        echo "   Fix: Add descriptive text inside the square brackets, e.g. [Link description](url)"
        FILE_VIOLATIONS=$((FILE_VIOLATIONS + 1))
        EXIT_CODE=1
    done < <(awk '{stripped=$0; gsub(/`[^`]*`/, "", stripped); if (stripped ~ /\[\][(\[]/) print NR ":" $0}' "$file" 2>/dev/null | head -20 || true)

    # Check for HTML anchor tags with no text content: <a ...></a> or <a ...> </a>
    # Uses awk to strip inline code spans before checking to avoid false positives on code examples
    while IFS= read -r line_info; do
        line_num="${line_info%%:*}"
        line_content="${line_info#*:}"
        echo "❌ $file (line $line_num): HTML anchor tag with no text content found"
        echo "   Content: ${line_content:0:120}"
        echo "   Fix: Add descriptive text between the opening and closing anchor tags"
        FILE_VIOLATIONS=$((FILE_VIOLATIONS + 1))
        EXIT_CODE=1
    done < <(awk '{stripped=$0; gsub(/`[^`]*`/, "", stripped); if (stripped ~ /<a [^>]*>[[:space:]]*<\/a>/) print NR ":" $0}' "$file" 2>/dev/null | head -20 || true)

    # Check for HTML anchor tags missing aria-label/aria-labelledby and with only whitespace or no content
    # This also catches <a href="..."/> self-closing anchors with no text
    # Uses awk to strip inline code spans before checking to avoid false positives on code examples
    while IFS= read -r line_info; do
        line_num="${line_info%%:*}"
        line_content="${line_info#*:}"
        echo "❌ $file (line $line_num): Self-closing anchor tag with no accessible text found"
        echo "   Content: ${line_content:0:120}"
        echo "   Fix: Add aria-label attribute or replace with a proper anchor tag containing text"
        FILE_VIOLATIONS=$((FILE_VIOLATIONS + 1))
        EXIT_CODE=1
    done < <(awk '{stripped=$0; gsub(/`[^`]*`/, "", stripped); if (stripped ~ /<a [^>]*\/>/ && stripped !~ /aria-label/ && stripped !~ /aria-labelledby/) print NR ":" $0}' "$file" 2>/dev/null | head -20 || true)

    TOTAL_VIOLATIONS=$((TOTAL_VIOLATIONS + FILE_VIOLATIONS))

    if [ $FILE_VIOLATIONS -eq 0 ]; then
        echo "✅ $file"
        FILES_PASSED=$((FILES_PASSED + 1))
    fi

done < <(find . -name "*.md" -type f -print0 | grep -zv ".git")

echo ""
echo "==========================================================="
echo "Summary: $FILES_PASSED/$FILES_CHECKED files have no link-name violations"
echo "Total violations found: $TOTAL_VIOLATIONS"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All links in markdown files have discernible text"
else
    echo "❌ Some links are missing discernible text (WCAG 2.1 link-name violation)"
    echo ""
    echo "To fix: Ensure all links have visible text, aria-label, or aria-labelledby"
    echo "Reference: https://dequeuniversity.com/rules/axe/4.11/link-name"
fi

exit $EXIT_CODE

#!/bin/bash
# Test script to check markdown files for links with discernible (non-empty) text
# This ensures WCAG 2.1 compliance with the link-name rule (links must have accessible text)
# Catches patterns like [](url) where the link text is empty or whitespace-only
# Skips inline code spans and fenced code blocks (which may show example patterns)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

echo "Checking markdown files for links with discernible text..."
echo "=========================================================="
echo ""

EXIT_CODE=0
FILES_CHECKED=0
FILES_PASSED=0
TOTAL_VIOLATIONS=0

check_file_for_empty_links() {
    local file="$1"
    local violations=0

    # Use awk to:
    #  1. Skip fenced code blocks (lines between ``` or ~~~)
    #  2. For each non-code line, remove inline code spans (content in backticks)
    #  3. Check for empty or whitespace-only link text []( or [  ](
    while IFS= read -r result; do
        line_num="${result%%:*}"
        line_content="${result#*:}"
        echo "❌ $file (line $line_num): Link with empty text found"
        echo "   Content: ${line_content:0:120}"
        violations=$((violations + 1))
    done < <(awk '
        /^[[:space:]]*(```|~~~)/ { in_code = !in_code; next }
        in_code { next }
        {
            line = $0
            # Remove all inline code spans (content between backticks)
            while (match(line, /`[^`]*`/)) {
                line = substr(line, 1, RSTART-1) substr(line, RSTART+RLENGTH)
            }
            # Check for empty or whitespace-only link text
            if (line ~ /\[[[:space:]]*\]\(/) {
                print NR ":" $0
            }
        }
    ' "$file" 2>/dev/null || true)

    # Same approach for image links with empty alt text [![](img)](url)
    while IFS= read -r result; do
        line_num="${result%%:*}"
        line_content="${result#*:}"
        echo "❌ $file (line $line_num): Image link with empty alt text found"
        echo "   Content: ${line_content:0:120}"
        violations=$((violations + 1))
    done < <(awk '
        /^[[:space:]]*(```|~~~)/ { in_code = !in_code; next }
        in_code { next }
        {
            line = $0
            while (match(line, /`[^`]*`/)) {
                line = substr(line, 1, RSTART-1) substr(line, RSTART+RLENGTH)
            }
            if (line ~ /!\[[[:space:]]*\]\(/) {
                print NR ":" $0
            }
        }
    ' "$file" 2>/dev/null || true)

    echo $violations
}

while IFS= read -r -d '' file; do
    FILES_CHECKED=$((FILES_CHECKED + 1))

    file_violations=$(check_file_for_empty_links "$file")
    TOTAL_VIOLATIONS=$((TOTAL_VIOLATIONS + file_violations))

    if [ "$file_violations" -eq 0 ]; then
        echo "✅ $file"
        FILES_PASSED=$((FILES_PASSED + 1))
    else
        EXIT_CODE=1
    fi
done < <(find . -name "*.md" -type f ! -path "*/.git/*" -print0)

echo ""
echo "=========================================================="
echo "Summary: $FILES_PASSED/$FILES_CHECKED files have no link-name violations"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All markdown links have discernible text"
else
    echo "❌ $TOTAL_VIOLATIONS link(s) found without discernible text"
    echo ""
    echo "To fix: Ensure all links use the format [descriptive text](url)"
    echo "Example: [World Economic Forum Jobs Report](https://www.weforum.org/...)"
    echo "Avoid:   [](https://www.weforum.org/...)"
    echo ""
    echo "For image links, add alt text: [![alt description](image.png)](url)"
fi

exit $EXIT_CODE

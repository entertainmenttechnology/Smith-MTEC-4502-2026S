#!/bin/bash
# Script to check that all markdown links have discernible (non-empty) text
# This helps prevent accessibility violations for the WCAG 2.1 link-name rule
# Skips inline code spans and fenced code blocks (which may show example patterns)
# See: https://dequeuniversity.com/rules/axe/4.11/link-name

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "Checking markdown files for links with discernible text..."
echo "=========================================================="

EXIT_CODE=0
CHECKED=0
VIOLATIONS=0

check_file_for_empty_links() {
    local file="$1"
    local count=0
    local rel_path="${file#$REPO_ROOT/}"

    # Use awk to:
    #  1. Skip fenced code blocks (lines between ``` or ~~~)
    #  2. For each non-code line, remove inline code spans (content in backticks)
    #  3. Check for empty or whitespace-only link text []( or [  ](
    while IFS= read -r result; do
        line_num="${result%%:*}"
        line_content="${result#*:}"
        echo "❌ Empty link text: $rel_path (line $line_num)"
        echo "   Content: ${line_content:0:120}"
        count=$((count + 1))
    done < <(awk '
        /^[[:space:]]*(```|~~~)/ { in_code = !in_code; next }
        in_code { next }
        {
            line = $0
            while (match(line, /`[^`]*`/)) {
                line = substr(line, 1, RSTART-1) substr(line, RSTART+RLENGTH)
            }
            if (line ~ /\[[[:space:]]*\]\(/) {
                print NR ":" $0
            }
        }
    ' "$file" 2>/dev/null || true)

    # Check for image links with empty alt text [![](img)](url)
    while IFS= read -r result; do
        line_num="${result%%:*}"
        line_content="${result#*:}"
        echo "❌ Empty image alt text in link: $rel_path (line $line_num)"
        echo "   Content: ${line_content:0:120}"
        count=$((count + 1))
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

    echo $count
}

# Find all markdown files (excluding .git directory and node_modules)
while IFS= read -r -d '' file; do
    CHECKED=$((CHECKED + 1))
    REL_PATH="${file#$REPO_ROOT/}"

    file_count=$(check_file_for_empty_links "$file")
    VIOLATIONS=$((VIOLATIONS + file_count))

    if [ "$file_count" -eq 0 ]; then
        echo "✅ All links have text: $REL_PATH"
    else
        EXIT_CODE=1
    fi
done < <(find "$REPO_ROOT" -name "*.md" -type f ! -path "*/\.git/*" ! -path "*/node_modules/*" -print0)

echo ""
echo "=========================================================="
echo "Results: Checked $CHECKED files, found $VIOLATIONS link-name violation(s)"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All markdown links have discernible text!"
else
    echo "❌ Some markdown links are missing discernible text."
    echo ""
    echo "To fix: Ensure all links follow the format [descriptive text](url)"
    echo "This is required for WCAG 2.1 accessibility compliance (link-name rule)."
fi

exit $EXIT_CODE

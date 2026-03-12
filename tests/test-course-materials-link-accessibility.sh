#!/bin/bash
# Test script to check that links in course-materials/README.md are distinguishable
# without relying on color alone, per WCAG 2.1 Success Criterion 1.4.1 (Use of Color)
# and the Deque axe rule: link-in-text-block
#
# Links must be visually distinguishable from surrounding text using a non-color
# indicator such as underline. This is achieved by using HTML anchor tags with
# explicit `text-decoration: underline` styling.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
FILE="$REPO_ROOT/course-materials/README.md"

echo "Testing course-materials/README.md for link accessibility..."
echo "============================================================="

EXIT_CODE=0

# 1. Check the file exists
if [ ! -f "$FILE" ]; then
    echo "❌ File not found: course-materials/README.md"
    exit 1
fi

# 2. Check for a level-one heading (H1) — required for WCAG 2.1 page-has-heading-one
if ! grep -q "^# " "$FILE"; then
    echo "❌ Missing level-one heading (# ) in course-materials/README.md"
    EXIT_CODE=1
else
    echo "✅ Level-one heading present"
fi

# 3. Check that no bare Markdown links ([text](url)) exist in the file.
#    Bare Markdown links rely solely on color to distinguish them from surrounding text,
#    violating WCAG 2.1 SC 1.4.1 when they appear in a text block.
#    All links should use HTML anchor tags with explicit underline styling instead.
BARE_LINKS=$(grep -nP '(?<![!\w])\[([^\]]+)\]\(([^)]+)\)' "$FILE" || true)
if [ -n "$BARE_LINKS" ]; then
    echo "❌ Found bare Markdown link(s) that rely on color alone for distinction:"
    echo "$BARE_LINKS"
    echo "   Fix: Replace with <a href=\"url\" style=\"text-decoration: underline;\">text</a>"
    EXIT_CODE=1
else
    echo "✅ No bare Markdown links found (all links use explicit styling)"
fi

# 4. Check that all HTML anchor tags have text-decoration: underline in their style attribute.
#    This ensures links are visually distinguishable without relying on color.
while IFS= read -r line; do
    # Match <a href="..."> tags that do NOT contain text-decoration: underline
    if echo "$line" | grep -qiP '<a\s[^>]*href='; then
        if ! echo "$line" | grep -qiP 'text-decoration\s*:\s*underline'; then
            echo "❌ Link missing text-decoration: underline style: $line"
            EXIT_CODE=1
        fi
    fi
done < "$FILE"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All HTML anchor tags have text-decoration: underline"
fi

echo ""
echo "============================================================="
if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ course-materials/README.md passes link accessibility checks"
else
    echo "❌ course-materials/README.md failed link accessibility checks"
    echo ""
    echo "To fix: Replace Markdown links with HTML anchor tags that include"
    echo "        style=\"text-decoration: underline;\" so links are visually"
    echo "        distinguishable from surrounding text without relying on color."
    echo "Example: <a href=\"https://example.com\" style=\"text-decoration: underline;\">Link text</a>"
fi

exit $EXIT_CODE

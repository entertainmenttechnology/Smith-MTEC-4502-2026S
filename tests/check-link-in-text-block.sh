#!/bin/bash
# Test script to check student-information.md for inline links in paragraph text
# that could trigger the WCAG 2.1 link-in-text-block accessibility rule.
#
# Background: An accessibility scan flagged the link-in-text-block rule on
# student-information.md. Links inside text blocks must be distinguishable
# from surrounding text without relying on color alone. This test ensures
# student-information.md does not contain plain (unstyled) inline links in
# paragraph text, which would require either bold wrapping (**[text](url)**)
# or HTML underline (<u>[text](url)</u>) to be accessible.
#
# Reference: https://dequeuniversity.com/rules/axe/4.11/link-in-text-block

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

FILE="$REPO_ROOT/student-information.md"
REL_FILE="student-information.md"
MAX_DISPLAY_LENGTH=120

echo "Checking $REL_FILE for link-in-text-block accessibility compliance..."
echo "======================================================================="
echo ""

if [ ! -f "$FILE" ]; then
    echo "❌ File not found: $REL_FILE"
    exit 1
fi

EXIT_CODE=0
VIOLATIONS=0
in_code_block=0

while IFS= read -r line; do
    # Track fenced code blocks (``` or ~~~)
    if [[ "$line" =~ ^\`\`\` ]] || [[ "$line" =~ ^\~\~\~ ]]; then
        if [ $in_code_block -eq 0 ]; then
            in_code_block=1
        else
            in_code_block=0
        fi
        continue
    fi

    # Skip content inside code blocks
    [ $in_code_block -eq 1 ] && continue

    # Skip headings (# through ######)
    [[ "$line" =~ ^#{1,6}[[:space:]] ]] && continue

    # Skip list items (unordered: -, *, + and ordered: 1. 2. etc.)
    [[ "$line" =~ ^[[:space:]]*[-\*\+][[:space:]] ]] && continue
    [[ "$line" =~ ^[[:space:]]*[0-9]+\.[[:space:]] ]] && continue

    # Skip table rows (lines containing | as a table separator)
    [[ "$line" =~ ^\|.*\| ]] && continue

    # Check for plain inline links in remaining paragraph text
    if echo "$line" | grep -qE '\[.+\]\(.+\)'; then
        # Allow bold-wrapped links: **[text](url)**
        echo "$line" | grep -qE '\*\*\[.+\]\(.+\)\*\*' && continue
        # Allow HTML underlined links: <u>...[text](url)...</u>
        echo "$line" | grep -qE '<u>.*\[.+\]\(.+\).*</u>' && continue

        # Plain inline link found — flag it
        VIOLATIONS=$((VIOLATIONS + 1))
        EXIT_CODE=1
        echo "  ❌ Plain inline link found in paragraph text:"
        echo "     ${line:0:$MAX_DISPLAY_LENGTH}"
        echo "     (links in text blocks must be distinguishable without relying on color)"
    fi
done < "$FILE"

echo ""
echo "======================================================================="
if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ $REL_FILE has no plain inline links in paragraph text"
    echo "   (link-in-text-block accessibility rule is satisfied)"
else
    echo "❌ $REL_FILE has $VIOLATIONS plain inline link(s) in paragraph text"
    echo ""
    echo "Links in paragraph text must be distinguishable without relying on color alone."
    echo "To fix, use one of the following:"
    echo "  1. Bold wrap:      **[link text](url)**"
    echo "  2. HTML underline: <u>[link text](url)</u>"
    echo "  3. Move link to a list item, table cell, or heading"
    echo ""
    echo "Reference: https://dequeuniversity.com/rules/axe/4.11/link-in-text-block"
fi

exit $EXIT_CODE

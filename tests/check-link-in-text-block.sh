#!/bin/bash
# Test script to check that markdown links in resource files are not embedded
# inline with surrounding text using the two-space line-break pattern.
#
# This ensures WCAG 2.1 accessibility (link-in-text-block / WCAG 1.4.1) by
# preventing the "[link text](url)  Description text" pattern that creates
# a <br>-separated link and description within the same <p> element.
# Such patterns can trigger the axe link-in-text-block rule because
# links may only be distinguished from surrounding text by color.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

echo "Checking resources/02_Resources.md for link-in-text-block patterns..."
echo "======================================================================="
echo ""

EXIT_CODE=0
FILES_CHECKED=0
FILES_PASSED=0

# Check the specific file that was flagged in the accessibility issue
TARGET_FILE="resources/02_Resources.md"

if [ ! -f "$TARGET_FILE" ]; then
    echo "❌ File not found: $TARGET_FILE"
    exit 1
fi

FILES_CHECKED=$((FILES_CHECKED + 1))
FILE_OK=1

# Detect the specific pattern that triggers link-in-text-block:
# A line that starts with a markdown link [text](url) immediately followed
# by two or more spaces and then description text (markdown line-break pattern).
# Pattern: ^[link text](url)  Description text
while IFS= read -r line_content; do
    # Check for line starting with a link (possibly bold **) followed by
    # two spaces and then non-whitespace text -- this is the problematic pattern
    if echo "$line_content" | grep -qP '^\s*\[.*?\]\([^)]+\)\s{2,}\S'; then
        echo "❌ $TARGET_FILE"
        echo "   Found link followed immediately by text on the same line:"
        echo "   $(echo "$line_content" | cut -c1-120)"
        echo ""
        FILE_OK=0
        EXIT_CODE=1
        break
    fi
    # Also check for bold-link pattern: [**text**](url)  Description
    if echo "$line_content" | grep -qP '^\s*\[\*\*.*?\*\*\]\([^)]+\)\s{2,}\S'; then
        echo "❌ $TARGET_FILE"
        echo "   Found bold link followed immediately by text on the same line:"
        echo "   $(echo "$line_content" | cut -c1-120)"
        echo ""
        FILE_OK=0
        EXIT_CODE=1
        break
    fi
done < "$TARGET_FILE"

if [ $FILE_OK -eq 1 ]; then
    echo "✅ $TARGET_FILE"
    echo "   No link-in-text-block patterns found"
    FILES_PASSED=$((FILES_PASSED + 1))
fi

echo ""
echo "======================================================================="
echo "Summary: $FILES_PASSED/$FILES_CHECKED files pass link-in-text-block check"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ resources/02_Resources.md has no link-in-text-block accessibility issues"
else
    echo "❌ resources/02_Resources.md has links immediately followed by text"
    echo ""
    echo "To fix: Separate each link from its description with a blank line."
    echo "Before:  [Link Text](url)  Description of the link"
    echo ""
    echo "After:   [Link Text](url)"
    echo ""
    echo "         Description of the link"
fi

exit $EXIT_CODE

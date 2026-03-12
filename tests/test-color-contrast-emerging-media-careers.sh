#!/bin/bash
# Test script to check that 02_emerging_media_careers.md has sufficient color contrast
# The intro paragraph must use an explicit high-contrast color override to meet
# WCAG 2.1 AA minimum contrast ratio of 4.5:1 against GitHub's #f6f8fa background.
#
# Background: GitHub's rendered blob view may apply a muted text color (#7b7c7d)
# which only achieves 3.92:1 contrast against #f6f8fa. Adding an explicit
# <font color="#24292f"> element ensures the text meets WCAG 2.1 AA requirements.
# The color #24292f achieves approximately 13.76:1 contrast against #f6f8fa.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
FILE="$REPO_ROOT/resources/02_emerging_media_careers.md"

echo "Testing $FILE for color contrast compliance..."
echo "=================================================="
echo ""

EXIT_CODE=0

# Check that the file exists
if [ ! -f "$FILE" ]; then
    echo "❌ File not found: $FILE"
    exit 1
fi

# Check that the intro paragraph uses an explicit high-contrast font color.
# The <font color="#24292f"> element ensures foreground text color provides
# at least 4.5:1 contrast ratio against GitHub's background color #f6f8fa.
if grep -q '<font color="#24292f">' "$FILE"; then
    echo "✅ Intro paragraph has explicit high-contrast color override (<font color=\"#24292f\">)"
    echo "   Contrast ratio: ~13.76:1 against #f6f8fa (WCAG 2.1 AA requires 4.5:1)"
else
    echo "❌ Missing high-contrast color override in intro paragraph"
    echo "   Expected: <font color=\"#24292f\"> in resources/02_emerging_media_careers.md"
    echo "   Reason: GitHub may render paragraph text with color #7b7c7d (3.92:1 contrast)"
    echo "   which does not meet WCAG 2.1 AA minimum contrast ratio of 4.5:1"
    EXIT_CODE=1
fi

# Check that the incomplete sentence fragment 'recall that $' is NOT present
# (i.e., the intro paragraph sentence is complete)
if grep -qE 'recall that[[:space:]]*$' "$FILE"; then
    echo "❌ Incomplete sentence detected: ends with 'recall that' without completing the thought"
    EXIT_CODE=1
else
    echo "✅ Intro paragraph sentence is complete (no hanging 'recall that' fragment)"
fi

echo ""
echo "=================================================="

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ Color contrast test passed for $FILE"
else
    echo "❌ Color contrast test failed for $FILE"
fi

exit $EXIT_CODE

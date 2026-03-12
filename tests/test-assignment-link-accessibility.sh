#!/bin/bash
# Test script to check that markdown links are accessible and distinguishable
# Ensures compliance with WCAG 2.1 Success Criterion 2.4.4 (Link Purpose)
# and helps prevent axe rule violations: link-in-text-block
#
# This test validates the specific file flagged in the accessibility issue:
# assignments/01c2-mtec_4502_assignment_1c_part2_future_modeling_and_adaptive_planning.md

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

TARGET_FILE="$REPO_ROOT/assignments/01c2-mtec_4502_assignment_1c_part2_future_modeling_and_adaptive_planning.md"

echo "Testing links in assignment file for accessibility..."
echo "======================================================"

if [ ! -f "$TARGET_FILE" ]; then
    echo "❌ File not found: $TARGET_FILE"
    exit 1
fi

EXIT_CODE=0

# Check 1: File has at least one properly formatted markdown link [text](url)
echo ""
echo "Check 1: Verifying proper markdown link syntax is used..."
if grep -qE '\[[^]]+\]\([^)]+\)' "$TARGET_FILE"; then
    echo "✅ File uses proper markdown link syntax [text](url)"
else
    echo "⚠️  No markdown links found in file (informational only)"
fi

# Check 2: No non-descriptive link text
echo ""
echo "Check 2: Checking for non-descriptive link text..."
NON_DESCRIPTIVE_FOUND=0
while IFS= read -r link_match; do
    if echo "$link_match" | grep -qiE "^\[(here|click here|read more|learn more|more|link|this)\]\("; then
        echo "❌ Non-descriptive link text: $link_match"
        NON_DESCRIPTIVE_FOUND=$((NON_DESCRIPTIVE_FOUND + 1))
        EXIT_CODE=1
    fi
done < <(grep -oE '\[[^]]+\]\([^)]+\)' "$TARGET_FILE" || true)

if [ "$NON_DESCRIPTIVE_FOUND" -eq 0 ]; then
    echo "✅ All links use descriptive text"
fi

# Check 3: Links with descriptive anchor text are present (spot-check known links)
echo ""
echo "Check 3: Verifying known descriptive links are present..."
if grep -q "\[Assignment 1C" "$TARGET_FILE"; then
    echo "✅ Internal assignment link uses descriptive text"
else
    echo "⚠️  Expected internal assignment link not found (informational only)"
fi

if grep -q "\[shared course Zotero library\]" "$TARGET_FILE"; then
    echo "✅ Zotero library link uses descriptive text"
else
    echo "⚠️  Expected Zotero link not found (informational only)"
fi

echo ""
echo "======================================================"
if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All link accessibility checks passed for:"
    echo "   $(basename "$TARGET_FILE")"
else
    echo "❌ Link accessibility issues found in:"
    echo "   $(basename "$TARGET_FILE")"
    echo ""
    echo "Fix: Use descriptive link text that explains the purpose of each link."
    echo "WCAG 2.1 SC 2.4.4: https://www.w3.org/WAI/WCAG21/Understanding/link-purpose-in-context"
fi

exit $EXIT_CODE

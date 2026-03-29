#!/bin/bash
# Test script to check that resources/09_portfolio_planning.md does not contain
# blockquote syntax (lines starting with "> ") that render with insufficient
# color contrast on GitHub (WCAG 2.1 AA requires 4.5:1 for normal text).
#
# GitHub renders blockquote text in a muted gray (#7b7c7d) against its page
# background (#f6f8fa), which only achieves a 3.92:1 contrast ratio — below
# the required 4.5:1 threshold.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

TARGET_FILE="$REPO_ROOT/resources/09_portfolio_planning.md"

echo "Checking $TARGET_FILE for blockquote syntax that may cause color contrast issues..."
echo "==================================================================================="

if [ ! -f "$TARGET_FILE" ]; then
    echo "❌ File not found: $TARGET_FILE"
    exit 1
fi

# Check for lines starting with ">" (markdown blockquote syntax, with or without a space)
if grep -qE "^>" "$TARGET_FILE"; then
    echo "❌ FAIL: Blockquote syntax detected in $TARGET_FILE"
    echo ""
    echo "The following lines use blockquote syntax (> ...) which renders with"
    echo "insufficient color contrast on GitHub (3.92:1 vs required 4.5:1):"
    echo ""
    grep -nE "^>" "$TARGET_FILE" | while IFS= read -r line; do
        echo "   $line"
    done
    echo ""
    echo "To fix: Remove the leading '> ' to render text as a regular paragraph"
    echo "with sufficient color contrast."
    exit 1
else
    echo "✅ PASS: No blockquote syntax found in $TARGET_FILE"
    echo "   Color contrast compliance maintained for WCAG 2.1 AA."
fi

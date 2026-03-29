#!/bin/bash
# Test that README.md links all have discernible text
# Ensures WCAG 2.1 compliance (link-name rule / SC 2.4.4: Link Purpose)
# See: https://dequeuniversity.com/rules/axe/4.11/link-name

set -e

FILE="README.md"

echo "Testing $FILE for links with discernible text..."
echo "================================================="

if [ ! -f "$FILE" ]; then
    echo "❌ File not found: $FILE"
    exit 1
fi

# Check for empty link text: [](...) or [ ](...)
EMPTY_LINKS=$(grep -nP '\[[ \t]*\]\s*\(' "$FILE" 2>/dev/null || true)

if [ -n "$EMPTY_LINKS" ]; then
    echo "❌ $FILE contains links with empty (non-discernible) text:"
    echo "$EMPTY_LINKS"
    echo ""
    echo "To fix: Add descriptive text between [ and ] for each link."
    echo "Example: [Visit homepage](https://example.com)"
    exit 1
else
    echo "✅ $FILE: all links have discernible text"
    echo ""
    # Show link count as confirmation
    LINK_COUNT=$(grep -cP '\[\S[^\]]*\]\s*\(' "$FILE" 2>/dev/null || echo "0")
    echo "   Found $LINK_COUNT link(s) — all have discernible text ✓"
    exit 0
fi

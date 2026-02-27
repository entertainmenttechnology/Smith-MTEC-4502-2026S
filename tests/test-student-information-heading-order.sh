#!/bin/bash
# Test that student-information.md has proper heading order (no skipped levels)
# Ensures WCAG 2.1 compliance by validating headings only increase by one level at a time

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FILE="$SCRIPT_DIR/../student-information.md"

echo "Testing $FILE for heading order..."

if [ ! -f "$FILE" ]; then
    echo "❌ File not found: $FILE"
    exit 1
fi

EXIT_CODE=0
PREV_LEVEL=0

while IFS= read -r line; do
    if [[ "$line" =~ ^(#{1,6})[[:space:]] ]]; then
        HASHES="${BASH_REMATCH[1]}"
        LEVEL=${#HASHES}
        if [ "$PREV_LEVEL" -gt 0 ] && [ "$LEVEL" -gt "$((PREV_LEVEL + 1))" ]; then
            echo "❌ Heading level skipped: jumped from h$PREV_LEVEL to h$LEVEL"
            echo "   Line: $line"
            EXIT_CODE=1
        fi
        PREV_LEVEL=$LEVEL
    fi
done < "$FILE"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ $FILE has proper heading order (no skipped levels)"
else
    echo ""
    echo "To fix: ensure heading levels only increase by one at a time"
    echo "Example: h1 -> h2 -> h3, not h1 -> h3"
fi

exit $EXIT_CODE

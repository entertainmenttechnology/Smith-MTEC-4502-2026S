#!/bin/bash
# Test script to check heading order in resources/speculative_future_careers.md
# Ensures heading levels only increase by one (WCAG 2.1 heading-order rule)
# This prevents axe accessibility violations due to skipped heading levels.

set -e

FILE="resources/speculative_future_careers.md"

echo "Testing $FILE for valid heading order..."

if [ ! -f "$FILE" ]; then
    echo "❌ File not found: $FILE"
    exit 1
fi

EXIT_CODE=0
PREV_LEVEL=0

while IFS= read -r line; do
    # Match lines that start with one or more '#' followed by a space
    if [[ "$line" =~ ^(#{1,6})[[:space:]] ]]; then
        hashes="${BASH_REMATCH[1]}"
        level=${#hashes}

        # First heading: must be level 1
        if [ "$PREV_LEVEL" -eq 0 ]; then
            if [ "$level" -ne 1 ]; then
                echo "❌ First heading is not level 1: $line"
                EXIT_CODE=1
            fi
        # Heading level must not skip (increase by more than 1)
        elif [ "$level" -gt $((PREV_LEVEL + 1)) ]; then
            echo "❌ Heading level skipped from h${PREV_LEVEL} to h${level}: $line"
            EXIT_CODE=1
        fi

        PREV_LEVEL=$level
    fi
done < "$FILE"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ $FILE has valid heading order (no levels skipped)"
    exit 0
else
    echo ""
    echo "To fix: ensure heading levels only increase by one."
    echo "Example: h1 → h2 → h3 is valid; h1 → h3 is not."
    exit 1
fi

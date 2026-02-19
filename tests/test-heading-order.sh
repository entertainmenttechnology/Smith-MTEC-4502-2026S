#!/bin/bash
# Test script to check that heading levels in student-information.md
# do not skip levels (e.g. jumping from H1 to H3 without an H2 in between).
# This ensures compliance with WCAG 2.1 / axe heading-order rule.

set -e

FILE="student-information.md"

echo "Testing $FILE for correct heading order..."

if [ ! -f "$FILE" ]; then
    echo "❌ File not found: $FILE"
    exit 1
fi

# Extract heading levels (number of leading '#' chars) in document order
heading_levels=()
while IFS= read -r line; do
    if [[ "$line" =~ ^(#{1,6})[[:space:]] ]]; then
        level="${#BASH_REMATCH[1]}"
        heading_levels+=("$level")
    fi
done < "$FILE"

if [ ${#heading_levels[@]} -eq 0 ]; then
    echo "❌ No headings found in $FILE"
    exit 1
fi

EXIT_CODE=0
prev_level=0

for level in "${heading_levels[@]}"; do
    if [ "$prev_level" -ne 0 ] && [ "$level" -gt "$((prev_level + 1))" ]; then
        echo "❌ Heading order invalid in $FILE: level H${prev_level} followed by H${level} (skipped a level)"
        EXIT_CODE=1
    fi
    prev_level="$level"
done

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ $FILE has valid heading order"
    echo "   Heading levels found: ${heading_levels[*]}"
fi

exit $EXIT_CODE

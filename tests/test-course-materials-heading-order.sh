#!/bin/bash
# Test script to check course-materials/README.md has a valid heading order
# Ensures WCAG 2.1 / axe heading-order rule compliance:
# heading levels must only increase by one at a time.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
FILE="$REPO_ROOT/course-materials/README.md"

echo "Testing $FILE for valid heading order..."

if [ ! -f "$FILE" ]; then
    echo "❌ File not found: $FILE"
    exit 1
fi

# Check that the file starts with a level-one heading
first_heading=$(grep -m1 '^#' "$FILE" 2>/dev/null || true)

if [[ "$first_heading" =~ ^#[[:space:]] ]]; then
    echo "✅ course-materials/README.md has a level-one heading"
    echo "   Heading: $first_heading"
else
    echo "❌ course-materials/README.md does not start with a level-one heading"
    echo "   First heading found: ${first_heading:-'(none)'}"
    echo "   Expected: A heading starting with '# ' (h1)"
    exit 1
fi

# Check heading order: no heading level should increase by more than one
prev_level=0
EXIT_CODE=0

while IFS= read -r line; do
    if [[ "$line" =~ ^(#{1,6})[[:space:]] ]]; then
        hashes="${BASH_REMATCH[1]}"
        level="${#hashes}"
        if [ "$prev_level" -gt 0 ] && [ "$level" -gt $((prev_level + 1)) ]; then
            echo "❌ Heading order violation: jumped from h${prev_level} to h${level}"
            echo "   Line: $line"
            EXIT_CODE=1
        fi
        prev_level="$level"
    fi
done < "$FILE"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ course-materials/README.md has valid heading order"
    exit 0
else
    echo "   Fix: Ensure heading levels only increase by one at a time."
    exit 1
fi

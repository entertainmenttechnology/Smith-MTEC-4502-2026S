#!/bin/bash
# Test script to verify markdown heading hierarchy
# This script checks that markdown files end with H3 or lower to prevent
# heading level jumps when GitHub adds H4 UI elements

set -e

echo "Testing heading hierarchy in markdown files..."

# File to test
FILE="assignments/01a_Reflective_essay_draft_speculation_phase.md"

# Get the last heading in the file
LAST_HEADING=$(grep "^#" "$FILE" | tail -1)

# Extract the heading level (count the number of # characters)
LEVEL=$(echo "$LAST_HEADING" | grep -o "^#*" | wc -c)
LEVEL=$((LEVEL - 1))  # Subtract 1 because wc includes newline

echo "File: $FILE"
echo "Last heading: $LAST_HEADING"
echo "Heading level: H$LEVEL"

# Check that the last heading is H3 or higher (to allow for GitHub's H4)
if [ "$LEVEL" -eq 1 ]; then
    echo "❌ FAIL: File ends with H1, which may cause heading level jump to H4"
    exit 1
elif [ "$LEVEL" -eq 2 ]; then
    echo "❌ FAIL: File ends with H2, which may cause heading level jump to H4"
    exit 1
elif [ "$LEVEL" -ge 3 ]; then
    echo "✅ PASS: File ends with H$LEVEL, which allows proper progression to H4"
    exit 0
else
    echo "❌ FAIL: Could not determine heading level"
    exit 1
fi

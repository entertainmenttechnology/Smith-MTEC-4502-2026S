#!/bin/bash
# Specific test for assignments/05-Assignment_Evaluating_Portfolio_Platforms.md accessibility
# Ensures the file has a level-one heading as required by WCAG 2.1
# This test prevents regression of the accessibility issue reported in GitHub issue

set -e

FILE="assignments/05-Assignment_Evaluating_Portfolio_Platforms.md"

echo "Testing $FILE for level-one heading..."

if [ ! -f "$FILE" ]; then
    echo "❌ File not found: $FILE"
    exit 1
fi

# Get first non-empty line
first_line=$(head -20 "$FILE" | grep -v '^[[:space:]]*$' | head -1)

if [[ "$first_line" =~ ^#[[:space:]]+ ]]; then
    echo "✅ $FILE has a level-one heading"
    echo "   Heading: $first_line"
    exit 0
else
    echo "❌ $FILE is missing a level-one heading"
    echo "   First non-empty line: $first_line"
    echo "   Expected: Line starting with '# '"
    exit 1
fi

#!/bin/bash
# Specific test for student-work/STUDENT-FOLDER-TEMPLATE.md accessibility
# Ensures the file has a level-one heading as required by WCAG 2.1

set -e

FILE="student-work/STUDENT-FOLDER-TEMPLATE.md"

echo "Testing $FILE for level-one heading..."

if [ ! -f "$FILE" ]; then
    echo "❌ File not found: $FILE"
    exit 1
fi

# Get first non-empty line (checking first 20 lines to allow for front matter)
first_line=$(head -20 "$FILE" | grep -v '^[[:space:]]*$' | head -1)

# Match exactly one # followed by a space (level-one heading only)
# The pattern ensures we don't match ## (level-two) or ### (level-three) etc.
if [[ "$first_line" =~ ^#[[:space:]].*$ ]] && [[ ! "$first_line" =~ ^##.*$ ]]; then
    echo "✅ $FILE has a level-one heading"
    echo "   Heading: $first_line"
    exit 0
else
    echo "❌ $FILE is missing a level-one heading"
    echo "   First non-empty line: $first_line"
    echo "   Expected: Line starting with '# '"
    exit 1
fi

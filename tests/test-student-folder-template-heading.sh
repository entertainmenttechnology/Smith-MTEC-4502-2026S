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

# Get first non-empty line that is a heading (skip YAML front matter)
# YAML front matter starts and ends with '---'
in_front_matter=false
first_heading=""
while IFS= read -r line; do
    # Skip empty lines
    [[ -z "${line// }" ]] && continue
    # Toggle front matter state
    if [[ "$line" == "---" ]]; then
        if [[ "$in_front_matter" == false ]]; then
            in_front_matter=true
            continue
        else
            in_front_matter=false
            continue
        fi
    fi
    # Skip lines inside front matter
    [[ "$in_front_matter" == true ]] && continue
    first_heading="$line"
    break
done < <(head -40 "$FILE")  # 40 lines is sufficient to cover typical front matter + first heading

if [[ "$first_heading" =~ ^#[[:space:]]+ ]]; then
    echo "✅ $FILE has a level-one heading"
    echo "   Heading: $first_heading"
    exit 0
else
    echo "❌ $FILE is missing a level-one heading"
    echo "   First non-empty line after front matter: $first_heading"
    echo "   Expected: Line starting with '# '"
    exit 1
fi

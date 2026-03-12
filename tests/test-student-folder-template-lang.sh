#!/bin/bash
# Specific test for student-work/STUDENT-FOLDER-TEMPLATE.md accessibility
# Ensures the file has a lang attribute in its YAML front matter as required by WCAG 2.1
# (html-has-lang rule: https://dequeuniversity.com/rules/axe/4.11/html-has-lang)

set -e

FILE="student-work/STUDENT-FOLDER-TEMPLATE.md"

echo "Testing $FILE for lang attribute in front matter..."

if [ ! -f "$FILE" ]; then
    echo "❌ File not found: $FILE"
    exit 1
fi

# Check for YAML front matter with a non-empty lang field
front_matter=$(head -10 "$FILE")
if echo "$front_matter" | grep -q "^lang:"; then
    lang_value=$(echo "$front_matter" | grep "^lang:" | head -1 | sed 's/^lang:[[:space:]]*//')
    if [ -n "$lang_value" ]; then
        echo "✅ $FILE has lang attribute: $lang_value"
        exit 0
    else
        echo "❌ $FILE has a lang field but it is empty"
        echo "   Expected: 'lang: en' or similar non-empty value"
        exit 1
    fi
else
    echo "❌ $FILE is missing a lang attribute in YAML front matter"
    echo "   Expected: YAML front matter with 'lang: en'"
    echo "   Add to the top of the file:"
    echo "   ---"
    echo "   lang: en"
    echo "   ---"
    exit 1
fi

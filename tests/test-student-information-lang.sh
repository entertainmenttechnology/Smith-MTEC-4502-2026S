#!/bin/bash
# Specific test for student-information.md accessibility
# Ensures the file has a lang front matter attribute as required by WCAG 2.1 SC 3.1.1
# (html-has-lang axe rule)

set -e

FILE="student-information.md"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

echo "Testing $FILE for lang front matter attribute..."

if [ ! -f "$FILE" ]; then
    echo "❌ File not found: $FILE"
    exit 1
fi

# Check for YAML front matter block and lang attribute within it
if awk '/^---/ && NR==1 { in_fm=1; next } in_fm && /^---/ { in_fm=0; next } in_fm && /^lang:/ { found=1 } END { exit !found }' "$FILE"; then
    lang_value=$(awk '/^---/ && NR==1 { in_fm=1; next } in_fm && /^---/ { in_fm=0; next } in_fm && /^lang:/ { print $2; exit }' "$FILE")
    echo "✅ $FILE has a lang front matter attribute: lang: $lang_value"
    echo "   This addresses the html-has-lang axe accessibility rule (WCAG 2.1 SC 3.1.1)"
    exit 0
else
    echo "❌ $FILE is missing a lang front matter attribute"
    echo "   Expected YAML front matter with 'lang: en' (or appropriate language code)"
    echo "   Example:"
    echo "   ---"
    echo "   lang: en"
    echo "   ---"
    echo "   # Page Title"
    exit 1
fi

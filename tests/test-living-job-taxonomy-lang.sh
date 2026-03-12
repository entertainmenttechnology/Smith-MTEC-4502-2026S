#!/bin/bash
# Test to verify resources/Living Job Taxonomy.md has a lang attribute in YAML front matter
# Ensures the html-has-lang accessibility violation (WCAG 2.1 SC 3.1.1) does not regress

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
FILE="$REPO_ROOT/resources/Living Job Taxonomy.md"

echo "Testing 'resources/Living Job Taxonomy.md' for lang attribute in front matter..."

if [ ! -f "$FILE" ]; then
    echo "❌ File not found: $FILE"
    exit 1
fi

# Check that the file starts with YAML front matter
first_line=$(head -n 1 "$FILE")
if [[ "$first_line" != "---" ]]; then
    echo "❌ File does not begin with YAML front matter (---)"
    echo "   First line: $first_line"
    exit 1
fi

# Check that the front matter contains a lang attribute
if awk '/^---/{if(found)exit; found=1; next} found && /^---/{exit} found{print}' "$FILE" | grep -q "^lang:"; then
    lang_value=$(awk '/^---/{if(found)exit; found=1; next} found && /^---/{exit} found{print}' "$FILE" | grep "^lang:" | head -1)
    echo "✅ 'resources/Living Job Taxonomy.md' has lang attribute: $lang_value"
    exit 0
else
    echo "❌ 'resources/Living Job Taxonomy.md' is missing lang attribute in front matter"
    echo "   To fix: Add 'lang: en' to the YAML front matter at the top of the file"
    echo "   This is required for WCAG 2.1 SC 3.1.1 (Language of Page)"
    exit 1
fi

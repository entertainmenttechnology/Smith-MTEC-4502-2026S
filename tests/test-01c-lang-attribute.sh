#!/bin/bash
# Test to verify the lang attribute is present in YAML front matter of
# assignments/01c MTEC 4502 Assignment week 3  - Integrating Visualization.md
# This ensures WCAG 2.1 SC 3.1.1 (Language of Page) compliance and
# prevents regression of the html-has-lang accessibility violation.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

FILE="assignments/01c MTEC 4502 Assignment week 3  - Integrating Visualization.md"
FULL_PATH="$REPO_ROOT/$FILE"

echo "Testing '$FILE' for lang attribute in YAML front matter..."

if [ ! -f "$FULL_PATH" ]; then
    echo "❌ File not found: $FILE"
    exit 1
fi

# Check that file starts with YAML front matter
first_line=$(head -n 1 "$FULL_PATH")
if [ "$first_line" != "---" ]; then
    echo "❌ File does not have YAML front matter (must start with '---')"
    echo "   First line: $first_line"
    exit 1
fi

# Extract front matter and check for lang attribute
front_matter=$(awk '/^---/{if(f)exit;f=1;next} f' "$FULL_PATH")

if echo "$front_matter" | grep -qE "^lang:"; then
    LANG_VALUE=$(echo "$front_matter" | grep -E "^lang:" | head -1 | sed 's/^lang:[[:space:]]*//')
    echo "✅ '$FILE' has lang attribute: lang=$LANG_VALUE"
    exit 0
else
    echo "❌ '$FILE' is missing lang attribute in YAML front matter"
    echo "   This is required to fix the html-has-lang accessibility violation (WCAG 2.1 SC 3.1.1)"
    echo ""
    echo "   To fix: Add 'lang: en' to the YAML front matter at the top of the file."
    echo "   Example:"
    echo "   ---"
    echo "   lang: en"
    echo "   ---"
    exit 1
fi

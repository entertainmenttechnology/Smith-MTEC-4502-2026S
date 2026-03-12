#!/bin/bash
# Script to check that all markdown files have a lang attribute in YAML front matter
# This prevents the html-has-lang accessibility violation (WCAG 2.1)
# Reference: https://dequeuniversity.com/rules/axe/4.11/html-has-lang

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "Checking markdown files for lang attribute in YAML front matter..."
echo "=================================================================="

EXIT_CODE=0
CHECKED=0
MISSING=0

# Find all markdown files (excluding .git directory and node_modules)
while IFS= read -r -d '' file; do
    CHECKED=$((CHECKED + 1))
    REL_PATH="${file#$REPO_ROOT/}"

    # Check if file starts with YAML front matter containing a lang attribute
    first_line=$(head -1 "$file")
    has_lang=false
    if [[ "$first_line" == "---" ]]; then
        front_matter=$(awk '
            BEGIN { in_fm = 0 }
            NR == 1 && /^---/ { in_fm = 1; next }
            in_fm && /^---/ { in_fm = 0; next }
            in_fm { print }
        ' "$file")
        if echo "$front_matter" | grep -qE "^lang:[[:space:]]+[a-zA-Z][a-zA-Z-]*"; then
            has_lang=true
        fi
    fi

    if [ "$has_lang" = true ]; then
        echo "✅ Has lang: $REL_PATH"
    else
        echo "❌ Missing lang: $REL_PATH"
        MISSING=$((MISSING + 1))
        EXIT_CODE=1
    fi
done < <(find "$REPO_ROOT" -name "*.md" -type f ! -path "*/\.git/*" ! -path "*/node_modules/*" -print0)

echo ""
echo "=================================================================="
echo "Results: Checked $CHECKED files, $MISSING missing lang attribute"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All markdown files have lang attribute in YAML front matter!"
else
    echo "❌ Some markdown files are missing the lang attribute."
    echo ""
    echo "To fix: Add YAML front matter at the top of each file with a lang attribute."
    echo "Example:"
    echo "  ---"
    echo "  lang: en"
    echo "  ---"
    echo ""
    echo "This is required to prevent the html-has-lang WCAG 2.1 accessibility violation."
fi

exit $EXIT_CODE

#!/bin/bash
# Script to check that all markdown files have a lang attribute in YAML front matter
# This helps prevent accessibility issues where HTML documents lack a lang attribute
# (WCAG 2.1 / axe rule: html-has-lang)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "Checking markdown files for lang attribute in front matter..."
echo "=============================================================="

EXIT_CODE=0
CHECKED=0
MISSING=0

# Find all markdown files (excluding .git directory and node_modules)
while IFS= read -r -d '' file; do
    CHECKED=$((CHECKED + 1))
    REL_PATH="${file#$REPO_ROOT/}"

    # Front matter must start on line 1 with '---'
    first_line=$(head -1 "$file")

    if [[ "$first_line" == "---" ]]; then
        # Extract front matter content and check for lang field
        if awk '/^---/{if(NR==1){found=1;next} if(found){exit}} found{print}' "$file" | grep -q "^lang:"; then
            echo "✅ Has lang: $REL_PATH"
        else
            echo "❌ Missing lang in front matter: $REL_PATH"
            MISSING=$((MISSING + 1))
            EXIT_CODE=1
        fi
    else
        echo "❌ Missing lang front matter: $REL_PATH"
        MISSING=$((MISSING + 1))
        EXIT_CODE=1
    fi
done < <(find "$REPO_ROOT" -name "*.md" -type f ! -path "*/\.git/*" ! -path "*/node_modules/*" -print0)

echo ""
echo "=============================================================="
echo "Results: Checked $CHECKED files, $MISSING missing lang attribute"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All markdown files have a lang attribute in front matter!"
else
    echo "❌ Some markdown files are missing a lang attribute in front matter."
    echo ""
    echo "To fix: Add YAML front matter with a 'lang' field at the top of each file."
    echo "This is required for WCAG 2.1 accessibility compliance (html-has-lang rule)."
    echo "Example:"
    echo "  ---"
    echo "  lang: en"
    echo "  ---"
fi

exit $EXIT_CODE

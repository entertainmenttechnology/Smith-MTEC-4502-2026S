#!/bin/bash
# Test script to check markdown files have a lang attribute in YAML front matter
# This ensures WCAG 2.1 compliance by validating that pages declare their language
# (html-has-lang rule: https://dequeuniversity.com/rules/axe/4.11/html-has-lang)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

echo "Checking markdown files for lang attribute in YAML front matter..."
echo "=================================================================="
echo ""

EXIT_CODE=0
FILES_CHECKED=0
FILES_PASSED=0

while IFS= read -r -d '' file; do
    # Skip hidden directories (like .git)
    if [[ "$file" == *"/.git/"* ]]; then
        continue
    fi

    FILES_CHECKED=$((FILES_CHECKED + 1))

    # Check if file starts with YAML front matter (---) and contains a lang: field
    first_line=$(head -1 "$file")
    if [[ "$first_line" == "---" ]]; then
        # Extract front matter block (between first and second ---)
        front_matter=$(awk '
            BEGIN { in_fm = 0 }
            NR == 1 && /^---/ { in_fm = 1; next }
            in_fm && /^---/ { in_fm = 0; next }
            in_fm { print }
        ' "$file")
        if echo "$front_matter" | grep -qE "^lang:[[:space:]]+[a-zA-Z][a-zA-Z-]*"; then
            echo "✅ $file"
            FILES_PASSED=$((FILES_PASSED + 1))
        else
            echo "❌ $file"
            echo "   YAML front matter found but missing 'lang' attribute"
            echo "   Expected: lang: en  (or appropriate language code)"
            EXIT_CODE=1
        fi
    else
        echo "❌ $file"
        echo "   Missing YAML front matter with 'lang' attribute"
        echo "   Expected: File to start with '---' front matter containing 'lang: en'"
        EXIT_CODE=1
    fi
done < <(find . -name "*.md" -type f ! -path "*/.git/*" -print0)

echo ""
echo "=================================================================="
echo "Summary: $FILES_PASSED/$FILES_CHECKED files have lang attribute in front matter"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All markdown files have lang attribute"
else
    echo "❌ Some markdown files are missing the lang attribute"
    echo ""
    echo "To fix: Add YAML front matter at the top of the file with a lang attribute."
    echo "Example:"
    echo "  ---"
    echo "  lang: en"
    echo "  ---"
fi

exit $EXIT_CODE

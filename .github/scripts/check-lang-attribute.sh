#!/bin/bash
# Script to check that all markdown files have a lang attribute in their YAML front matter
# This helps prevent accessibility issues where pages lack a language declaration
# (html-has-lang rule: https://dequeuniversity.com/rules/axe/4.11/html-has-lang)

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

    # Extract lang value from YAML front matter only (between leading '---' delimiters)
    lang_value=""
    in_front_matter=false
    while IFS= read -r fm_line; do
        if [[ "$fm_line" == "---" ]]; then
            if [[ "$in_front_matter" == false ]]; then
                in_front_matter=true
            else
                break  # End of front matter
            fi
        elif [[ "$in_front_matter" == true && "$fm_line" =~ ^lang:[[:space:]]*(.+)$ ]]; then
            lang_value="${BASH_REMATCH[1]}"
            break
        fi
    done < <(head -20 "$file")

    if [ -n "$lang_value" ]; then
        echo "✅ Has lang ($lang_value): $REL_PATH"
    else
        echo "❌ Missing lang: $REL_PATH"
        MISSING=$((MISSING + 1))
        EXIT_CODE=1
    fi
done < <(find "$REPO_ROOT" -name "*.md" -type f ! -path "*/\.git/*" ! -path "*/node_modules/*" -print0)

echo ""
echo "=============================================================="
echo "Results: Checked $CHECKED files, $MISSING missing lang attribute"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All markdown files have a lang attribute!"
else
    echo "❌ Some markdown files are missing a lang attribute."
    echo ""
    echo "To fix: Add YAML front matter with 'lang: en' at the top of each file."
    echo "Example:"
    echo "  ---"
    echo "  lang: en"
    echo "  ---"
    echo ""
    echo "This is required to meet WCAG 2.1 accessibility guidelines (html-has-lang rule)."
fi

exit $EXIT_CODE

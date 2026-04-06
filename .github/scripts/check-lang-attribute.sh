#!/bin/bash
# Script to check that markdown files with YAML front matter declare a lang attribute
# Files without front matter are skipped; files with front matter must declare lang
# This enforces WCAG 2.1 SC 3.1.1 (Language of Page) compliance

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "Checking markdown files for lang attribute in front matter..."
echo "============================================================="

EXIT_CODE=0
CHECKED=0
HAS_FRONTMATTER=0
MISSING_LANG=0
SKIPPED=0

# Find all markdown files (excluding .git directory and node_modules)
while IFS= read -r -d '' file; do
    CHECKED=$((CHECKED + 1))
    REL_PATH="${file#$REPO_ROOT/}"

    # Check if file starts with YAML front matter (--- delimiter)
    first_line=$(head -n 1 "$file")
    if [ "$first_line" != "---" ]; then
        SKIPPED=$((SKIPPED + 1))
        continue
    fi

    HAS_FRONTMATTER=$((HAS_FRONTMATTER + 1))

    # Extract front matter block (between first --- and second ---)
    front_matter=$(awk '/^---/{if(f)exit;f=1;next} f' "$file")

    # Check if front matter has a lang attribute
    if echo "$front_matter" | grep -qE "^lang:"; then
        LANG_VALUE=$(echo "$front_matter" | grep -E "^lang:" | head -1 | sed 's/^lang:[[:space:]]*//')
        echo "✅ Has lang attribute ($LANG_VALUE): $REL_PATH"
    else
        echo "❌ Missing lang attribute in front matter: $REL_PATH"
        MISSING_LANG=$((MISSING_LANG + 1))
        EXIT_CODE=1
    fi
done < <(find "$REPO_ROOT" -name "*.md" -type f ! -path "*/\.git/*" ! -path "*/node_modules/*" -print0)

echo ""
echo "============================================================="
echo "Results: Checked $CHECKED files total, $HAS_FRONTMATTER with front matter, $MISSING_LANG missing lang attribute, $SKIPPED skipped (no front matter)"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All markdown files with front matter have a lang attribute!"
else
    echo "❌ Some markdown files with front matter are missing a lang attribute."
    echo ""
    echo "To fix: Add a lang attribute to the YAML front matter."
    echo "Example:"
    echo "  ---"
    echo "  lang: en"
    echo "  ---"
    echo ""
    echo "This is required for WCAG 2.1 SC 3.1.1 (Language of Page) compliance."
fi

exit $EXIT_CODE

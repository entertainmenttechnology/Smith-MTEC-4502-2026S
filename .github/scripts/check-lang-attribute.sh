#!/bin/bash
# Script to check that markdown files with YAML frontmatter include a lang attribute
# Satisfies WCAG 2.1 Success Criterion 3.1.1 (Language of Page)
#
# Files that already declare YAML frontmatter (---) are required to include a lang
# attribute so that static site generators can render <html lang="...">.  Files
# without any frontmatter are skipped.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "Checking markdown files with frontmatter for lang attribute..."
echo "=============================================================="

EXIT_CODE=0
CHECKED=0
MISSING=0
SKIPPED=0

# Find all markdown files (excluding .git directory and node_modules)
while IFS= read -r -d '' file; do
    REL_PATH="${file#$REPO_ROOT/}"

    # Only inspect files that start with a YAML frontmatter delimiter
    first_line=$(head -1 "$file")
    if [[ "$first_line" != "---" ]]; then
        SKIPPED=$((SKIPPED + 1))
        continue
    fi

    CHECKED=$((CHECKED + 1))

    # Extract frontmatter block (between the first and second ---)
    frontmatter=$(awk 'NR==1{next} /^---/{exit} {print}' "$file")

    if echo "$frontmatter" | grep -q "^lang:"; then
        echo "✅ Has lang: $REL_PATH"
    else
        echo "❌ Missing lang: $REL_PATH"
        MISSING=$((MISSING + 1))
        EXIT_CODE=1
    fi
done < <(find "$REPO_ROOT" -name "*.md" -type f ! -path "*/\.git/*" ! -path "*/node_modules/*" -print0)

echo ""
echo "=============================================================="
echo "Results: Checked $CHECKED files with frontmatter, $MISSING missing lang attribute ($SKIPPED skipped – no frontmatter)"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All markdown files with frontmatter have a lang attribute!"
else
    echo "❌ Some markdown files with frontmatter are missing a lang attribute."
    echo ""
    echo "To fix: Add a lang key to the YAML frontmatter block at the top of the file."
    echo "Example:"
    echo "  ---"
    echo "  lang: en"
    echo "  ---"
    echo ""
    echo "This is required for WCAG 2.1 SC 3.1.1 (Language of Page) compliance."
fi

exit $EXIT_CODE

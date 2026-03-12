#!/bin/bash
# Script to check that all markdown files have a lang attribute in YAML front matter
# This helps prevent accessibility issues where HTML pages lack a lang attribute on <html>
# Required for WCAG 2.1 Success Criterion 3.1.1 (Language of Page)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "Checking markdown files for lang attribute in front matter..."
echo "=============================================================="

EXIT_CODE=0
CHECKED=0
MISSING=0

# Find all markdown files (excluding .github internal docs and node_modules)
while IFS= read -r -d '' file; do
    CHECKED=$((CHECKED + 1))
    REL_PATH="${file#$REPO_ROOT/}"

    # Check if file begins with YAML front matter containing a lang attribute
    # Front matter must start at line 1 with ---
    first_line=$(head -n 1 "$file")
    if [[ "$first_line" == "---" ]]; then
        # Extract front matter block and check for lang key
        if awk '/^---/{if(found)exit; found=1; next} found && /^---/{exit} found{print}' "$file" | grep -q "^lang:"; then
            echo "✅ Has lang: $REL_PATH"
        else
            echo "❌ Missing lang in front matter: $REL_PATH"
            MISSING=$((MISSING + 1))
            EXIT_CODE=1
        fi
    else
        echo "❌ Missing front matter (no lang): $REL_PATH"
        MISSING=$((MISSING + 1))
        EXIT_CODE=1
    fi
done < <(find "$REPO_ROOT" -name "*.md" -type f \
    ! -path "*/\.git/*" \
    ! -path "*/node_modules/*" \
    ! -path "*/.github/*" \
    -print0)

echo ""
echo "=============================================================="
echo "Results: Checked $CHECKED files, $MISSING missing lang attribute"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All markdown files have a lang attribute in front matter!"
else
    echo "❌ Some markdown files are missing a lang attribute."
    echo ""
    echo "To fix: Add YAML front matter with a lang attribute to the top of each file."
    echo "Example:"
    echo "  ---"
    echo "  lang: en"
    echo "  ---"
    echo ""
    echo "This is required for WCAG 2.1 Success Criterion 3.1.1 (Language of Page)."
fi

exit $EXIT_CODE

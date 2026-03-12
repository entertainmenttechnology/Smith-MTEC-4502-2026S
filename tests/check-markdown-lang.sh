#!/bin/bash
# Test script to check markdown files have a lang front matter attribute for accessibility compliance
# This ensures WCAG 2.1 SC 3.1.1 compliance by validating that pages specify their human language
# (addresses the html-has-lang axe accessibility rule)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

echo "Checking markdown files for lang front matter attribute..."
echo "=========================================================="
echo ""

EXIT_CODE=0
FILES_CHECKED=0
FILES_PASSED=0

while IFS= read -r -d '' file; do
    # Skip hidden directories (like .git, .github)
    if [[ "$file" == *"/.git/"* ]] || [[ "$file" == *"/.github/"* ]]; then
        continue
    fi

    FILES_CHECKED=$((FILES_CHECKED + 1))
    REL_PATH="${file#$REPO_ROOT/}"

    # Check for YAML front matter block containing a lang attribute
    if awk '/^---/ && NR==1 { in_fm=1; next } in_fm && /^---/ { in_fm=0; next } in_fm && /^lang:/ { found=1 } END { exit !found }' "$file"; then
        echo "✅ $REL_PATH"
        FILES_PASSED=$((FILES_PASSED + 1))
    else
        echo "❌ $REL_PATH"
        echo "   Missing: YAML front matter with 'lang:' attribute"
        EXIT_CODE=1
    fi
done < <(find "$REPO_ROOT" -name "*.md" -type f -print0 | grep -zv ".git")

echo ""
echo "=========================================================="
echo "Summary: $FILES_PASSED/$FILES_CHECKED files have a lang front matter attribute"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All markdown files have a lang front matter attribute"
else
    echo "❌ Some markdown files are missing a lang front matter attribute"
    echo ""
    echo "To fix: Add a lang attribute in YAML front matter at the top of the file."
    echo "Example:"
    echo "  ---"
    echo "  lang: en"
    echo "  ---"
    echo "  # Page Title"
fi

exit $EXIT_CODE

#!/bin/bash
# Test script to check markdown files have a lang attribute in their YAML front matter
# This ensures WCAG 2.1 compliance by validating that pages declare a language,
# which is used by static site generators to set the lang attribute on the <html> element.

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

    # Check if file starts with YAML front matter containing a lang attribute
    # Front matter is delimited by --- at start and end
    first_lines=$(head -5 "$file")
    
    if echo "$first_lines" | grep -q "^---" && echo "$first_lines" | grep -q "^lang:"; then
        echo "✅ $file"
        FILES_PASSED=$((FILES_PASSED + 1))
    else
        echo "❌ $file"
        echo "   Missing: YAML front matter with 'lang:' attribute"
        echo "   Expected front matter at top of file:"
        echo "   ---"
        echo "   lang: en"
        echo "   ---"
        EXIT_CODE=1
    fi
done < <(find . -name "*.md" -type f -print0 | grep -zv ".git")

echo ""
echo "=================================================================="
echo "Summary: $FILES_PASSED/$FILES_CHECKED files have lang attribute in front matter"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All markdown files have a lang attribute"
else
    echo "❌ Some markdown files are missing a lang attribute"
    echo ""
    echo "To fix: Add YAML front matter with 'lang: en' at the top of each file:"
    echo "---"
    echo "lang: en"
    echo "---"
fi

exit $EXIT_CODE

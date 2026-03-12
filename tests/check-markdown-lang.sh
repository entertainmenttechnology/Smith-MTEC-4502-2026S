#!/bin/bash
# Test script to check markdown files have a lang attribute in YAML front matter
# This ensures WCAG 2.1 compliance (html-has-lang rule) by validating that
# documents declare their language, enabling renderers to set <html lang="...">.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

echo "Checking markdown files for lang front matter..."
echo "=================================================="
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

    # Check if file starts with YAML front matter (---) and contains a lang field
    # Front matter must be at the very start of the file
    first_line=$(head -1 "$file")

    if [[ "$first_line" == "---" ]]; then
        # Extract front matter block and check for lang field
        if awk '/^---/{if(NR==1){found=1;next} if(found){exit}} found{print}' "$file" | grep -q "^lang:"; then
            echo "✅ $file"
            FILES_PASSED=$((FILES_PASSED + 1))
        else
            echo "❌ $file"
            echo "   Has YAML front matter but missing 'lang:' field"
            echo "   Expected: Add 'lang: en' (or appropriate language code) to the front matter"
            EXIT_CODE=1
        fi
    else
        echo "❌ $file"
        echo "   Missing YAML front matter with 'lang:' field"
        echo "   Expected: Add front matter block at the top of the file, e.g.:"
        echo "   ---"
        echo "   lang: en"
        echo "   ---"
        EXIT_CODE=1
    fi
done < <(find . -name "*.md" -type f -print0 | grep -zv ".git")

echo ""
echo "=================================================="
echo "Summary: $FILES_PASSED/$FILES_CHECKED files have a lang attribute in front matter"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All markdown files have a lang attribute in front matter"
else
    echo "❌ Some markdown files are missing a lang attribute in front matter"
    echo ""
    echo "To fix: Add YAML front matter with a 'lang' field at the top of each file."
    echo "This allows HTML renderers to set <html lang=\"...\"> for WCAG 2.1 compliance."
    echo "Example:"
    echo "  ---"
    echo "  lang: en"
    echo "  ---"
fi

exit $EXIT_CODE

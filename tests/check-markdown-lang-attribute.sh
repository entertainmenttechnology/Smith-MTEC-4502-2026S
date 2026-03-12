#!/bin/bash
# Test script to check markdown files have a lang attribute in YAML front matter
# This ensures WCAG 2.1 compliance by validating that pages declare their language
# (html-has-lang axe rule)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

echo "Checking markdown files for lang attribute in front matter..."
echo "============================================================="
echo ""

EXIT_CODE=0
FILES_CHECKED=0
FILES_PASSED=0

# List of files required to have a lang attribute in their front matter
REQUIRED_FILES=(
    "resources/09_portfolio_planning.md"
)

for file in "${REQUIRED_FILES[@]}"; do
    FILES_CHECKED=$((FILES_CHECKED + 1))

    if [ ! -f "$file" ]; then
        echo "❌ $file (file not found)"
        EXIT_CODE=1
        continue
    fi

    # Extract lang from YAML front matter (between first pair of --- delimiters)
    lang_value=$(awk '
        BEGIN { in_front_matter=0; found=0 }
        /^---/ && NR==1 { in_front_matter=1; next }
        /^---/ && in_front_matter { exit }
        in_front_matter && /^lang:/ { gsub(/^lang:[[:space:]]*/, ""); print; found=1; exit }
    ' "$file")

    if [[ -n "$lang_value" ]]; then
        echo "✅ $file (lang: $lang_value)"
        FILES_PASSED=$((FILES_PASSED + 1))
    else
        echo "❌ $file"
        echo "   Missing 'lang' attribute in YAML front matter"
        echo "   Expected: Add YAML front matter at the top of the file:"
        echo "     ---"
        echo "     lang: en"
        echo "     ---"
        EXIT_CODE=1
    fi
done

echo ""
echo "============================================================="
echo "Summary: $FILES_PASSED/$FILES_CHECKED files have lang attribute"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All checked markdown files have a lang attribute"
else
    echo "❌ Some markdown files are missing a lang attribute"
    echo ""
    echo "To fix: Add YAML front matter with a lang attribute at the top of the file:"
    echo "  ---"
    echo "  lang: en"
    echo "  ---"
fi

exit $EXIT_CODE

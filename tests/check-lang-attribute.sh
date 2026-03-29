#!/bin/bash
# Test script to check markdown files have a lang attribute in YAML front matter
# This ensures the html-has-lang WCAG 2.1 / axe accessibility rule is satisfied
# when pages are served via Jekyll or GitHub Pages.
#
# Checks that files contain:
#   ---
#   lang: <value>
#   ---
# at the top of the file.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Files that must have a lang front-matter attribute.
# Extend this list when new files are flagged by accessibility scans.
REQUIRED_FILES=(
    "assignments/01a-d Scaffolded Assignment_ Reflective and analytical essay.md"
)

echo "Checking markdown files for lang front matter (html-has-lang)..."
echo "================================================================="
echo ""

EXIT_CODE=0
FILES_CHECKED=0
FILES_PASSED=0

for rel_file in "${REQUIRED_FILES[@]}"; do
    file="$REPO_ROOT/$rel_file"
    FILES_CHECKED=$((FILES_CHECKED + 1))

    if [ ! -f "$file" ]; then
        echo "❌ $rel_file  (file not found)"
        EXIT_CODE=1
        continue
    fi

    # Check that the file starts with a YAML front matter block (--- ... ---)
    # containing a lang key, e.g.:
    #   ---
    #   lang: en
    #   ---
    first_line=$(head -n 1 "$file")
    in_front_matter=false
    found_lang=false

    if [ "$first_line" = "---" ]; then
        in_front_matter=true
        while IFS= read -r line; do
            if $in_front_matter; then
                if [ "$line" = "---" ]; then
                    break
                fi
                if echo "$line" | grep -q "^lang:"; then
                    found_lang=true
                fi
            fi
        done < <(tail -n +2 "$file")
    fi

    if $found_lang; then
        echo "✅ $rel_file"
        FILES_PASSED=$((FILES_PASSED + 1))
    else
        echo "❌ $rel_file"
        echo "   Missing 'lang:' in YAML front matter."
        echo "   Add the following at the very top of the file:"
        echo "     ---"
        echo "     lang: en"
        echo "     ---"
        EXIT_CODE=1
    fi
done

echo ""
echo "================================================================="
echo "Summary: $FILES_PASSED/$FILES_CHECKED files have a lang front matter attribute"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All required markdown files have a lang front matter attribute"
else
    echo "❌ Some markdown files are missing a lang front matter attribute"
    echo ""
    echo "To fix: Add 'lang: en' inside a YAML front matter block at the top of the file."
    echo "This satisfies the html-has-lang axe/WCAG 2.1 accessibility requirement."
fi

exit $EXIT_CODE

#!/bin/bash
# Test script to check markdown files have lang front matter for accessibility compliance
# This ensures WCAG 2.1 Language of Page (3.1.1) compliance by validating that pages
# declare their language via YAML front matter (used by Jekyll/GitHub Pages and HTML converters).

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

# Files that are required to have lang front matter
# Add files here as they are fixed to prevent regression
REQUIRED_FILES=(
    "assignments/01c2-mtec_4502_assignment_1c_part2_future_modeling_and_adaptive_planning.md"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo "❌ File not found: $file"
        EXIT_CODE=1
        continue
    fi

    FILES_CHECKED=$((FILES_CHECKED + 1))

    # Check that file starts with YAML front matter delimiter and contains lang: field
    first_line=$(head -1 "$file")
    has_lang=$(head -10 "$file" | grep -c "^lang:" || true)

    if [[ "$first_line" == "---" ]] && [[ "$has_lang" -gt 0 ]]; then
        echo "✅ $file"
        FILES_PASSED=$((FILES_PASSED + 1))
    else
        echo "❌ $file"
        echo "   Missing lang front matter (e.g., lang: en)"
        echo "   Expected: File to start with '---' and include 'lang: en' in front matter"
        EXIT_CODE=1
    fi
done

echo ""
echo "=================================================="
echo "Summary: $FILES_PASSED/$FILES_CHECKED files have lang front matter"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All required markdown files have lang front matter"
else
    echo "❌ Some markdown files are missing lang front matter"
    echo ""
    echo "To fix: Add YAML front matter at the very start of the file:"
    echo "---"
    echo "lang: en"
    echo "---"
    echo ""
    echo "This satisfies WCAG 2.1 Language of Page (3.1.1) and the axe html-has-lang rule."
fi

exit $EXIT_CODE

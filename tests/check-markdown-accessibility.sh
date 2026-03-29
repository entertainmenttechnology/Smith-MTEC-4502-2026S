#!/bin/bash
# Test script to check markdown files have level-one headings for accessibility compliance
# This ensures WCAG 2.1 compliance by validating that pages have proper heading structure

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

echo "Checking markdown files for level-one headings..."
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
    
    # Check if any of the first 30 lines starts with "# " (level-one heading)
    # Allow for HTML landmark wrappers (e.g. <main>) before the heading
    if head -30 "$file" | grep -q "^# "; then
        echo "✅ $file"
        FILES_PASSED=$((FILES_PASSED + 1))
    else
        first_line=$(head -30 "$file" | grep -v '^[[:space:]]*$' | head -1)
        echo "❌ $file"
        echo "   First non-empty line: ${first_line:0:80}"
        echo "   Expected: A line starting with '# ' (level-one heading) within first 30 lines"
        EXIT_CODE=1
    fi
done < <(find . -name "*.md" -type f -print0 | grep -zv ".git")

echo ""
echo "=================================================="
echo "Summary: $FILES_PASSED/$FILES_CHECKED files have level-one headings"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All markdown files have level-one headings"
else
    echo "❌ Some markdown files are missing level-one headings"
    echo ""
    echo "To fix: Add a level-one heading (starting with '# ') within the first 30 lines"
    echo "Example: # Page Title"
fi

exit $EXIT_CODE

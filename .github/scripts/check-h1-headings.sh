#!/bin/bash
# Script to check if markdown files have level-one headings
# This prevents accessibility violations (page-has-heading-one)

set -e

FAILED=0
ERRORS=""

echo "Checking markdown files for level-one headings..."

# Find all markdown files (excluding node_modules and .git)
while IFS= read -r file; do
    # Check if file has a level-one heading (line starting with single #)
    if ! grep -q "^# " "$file"; then
        FAILED=$((FAILED + 1))
        ERRORS="${ERRORS}\n❌ Missing level-one heading: $file"
        echo "❌ FAIL: $file (no level-one heading found)"
    else
        echo "✅ PASS: $file"
    fi
done < <(find . -name "*.md" -type f | grep -v -E "(node_modules|\.git)" | sort)

echo ""
echo "===================="
if [ $FAILED -eq 0 ]; then
    echo "✅ All markdown files have level-one headings!"
    exit 0
else
    echo "❌ $FAILED markdown file(s) missing level-one headings"
    echo -e "$ERRORS"
    exit 1
fi

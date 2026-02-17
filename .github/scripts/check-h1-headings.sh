#!/bin/bash
# Script to check if markdown files have level-one headings
# This prevents accessibility violations (page-has-heading-one)

set -e

FAILED=0
ERRORS=""

# Directories to exclude from validation
EXCLUDE_PATTERN="node_modules|\.git|vendor|dist|build"

echo "Checking markdown files for level-one headings..."

# Find all markdown files (excluding common non-source directories)
while IFS= read -r file; do
    # Check if file has a level-one heading (line starting with # followed by space)
    # Note: Requires space after # for consistency with common markdown style
    if ! grep -q "^#[[:space:]]" "$file"; then
        FAILED=$((FAILED + 1))
        ERRORS="${ERRORS}\n❌ Missing level-one heading: $file"
        echo "❌ FAIL: $file (no level-one heading found)"
    else
        echo "✅ PASS: $file"
    fi
done < <(find . -name "*.md" -type f | grep -v -E "$EXCLUDE_PATTERN" | sort)

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

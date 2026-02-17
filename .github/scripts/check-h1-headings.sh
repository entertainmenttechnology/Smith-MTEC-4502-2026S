#!/bin/bash
# Script to check that all markdown files have a level-one heading (#)
# This helps prevent accessibility issues where pages lack proper headings

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "Checking markdown files for level-one headings..."
echo "=================================================="

EXIT_CODE=0
CHECKED=0
MISSING=0

# Find all markdown files (excluding .git directory and node_modules)
while IFS= read -r -d '' file; do
    CHECKED=$((CHECKED + 1))
    REL_PATH="${file#$REPO_ROOT/}"
    
    # Check if file has a level-one heading (# ) in first 30 lines
    # Allow for front matter and initial blank lines
    if ! head -n 30 "$file" | grep -q "^# "; then
        echo "❌ Missing H1: $REL_PATH"
        MISSING=$((MISSING + 1))
        EXIT_CODE=1
    else
        echo "✅ Has H1: $REL_PATH"
    fi
done < <(find "$REPO_ROOT" -name "*.md" -type f ! -path "*/\.git/*" ! -path "*/node_modules/*" -print0)

echo ""
echo "=================================================="
echo "Results: Checked $CHECKED files, $MISSING missing H1 headings"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All markdown files have level-one headings!"
else
    echo "❌ Some markdown files are missing level-one headings."
    echo ""
    echo "To fix: Add a level-one heading (e.g., '# Title') near the top of each file."
    echo "This is required for WCAG 2.1 accessibility compliance."
fi

exit $EXIT_CODE

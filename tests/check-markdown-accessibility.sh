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
    
    # Check if first non-empty line starts with "# " (level-one heading)
    first_line=$(head -20 "$file" | grep -v '^[[:space:]]*$' | head -1)
    
    if [[ "$first_line" =~ ^#[[:space:]]+ ]]; then
        echo "✅ $file"
        FILES_PASSED=$((FILES_PASSED + 1))
    else
        echo "❌ $file"
        echo "   First non-empty line: ${first_line:0:80}"
        echo "   Expected: Line starting with '# ' (level-one heading)"
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
    echo "To fix: Add a level-one heading (starting with '# ') as the first non-empty line"
    echo "Example: # Page Title"
fi

echo ""
echo "Checking color contrast: blockquote usage in Living Job Taxonomy.md..."
echo "======================================================================="
echo "GitHub renders blockquote text with a muted color (~#7b7c7d) that fails"
echo "WCAG 2 AA contrast against the page background (#f6f8fa). Blockquotes"
echo "must not be used for non-quoted content in this file."
echo ""

TAXONOMY_FILE="resources/Living Job Taxonomy.md"
if [ -f "$TAXONOMY_FILE" ]; then
    if grep -qP '^>\s' "$TAXONOMY_FILE"; then
        echo "❌ $TAXONOMY_FILE contains blockquote syntax (lines starting with '>')"
        echo "   Blockquotes render with muted text color (#7b7c7d) on GitHub, which"
        echo "   fails WCAG 2 AA color contrast (3.92:1 vs required 4.5:1)."
        echo "   Replace blockquote syntax with regular paragraph text."
        EXIT_CODE=1
    else
        echo "✅ $TAXONOMY_FILE has no blockquote syntax (color contrast safe)"
    fi
else
    echo "⚠️  $TAXONOMY_FILE not found — skipping blockquote check"
fi

echo ""

exit $EXIT_CODE

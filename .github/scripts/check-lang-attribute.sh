#!/bin/bash
# Script to check that all markdown files declare a document language
# via YAML front matter (lang: en or similar).
# This supports the WCAG 2.1 / axe html-has-lang requirement by ensuring
# every document carries explicit language metadata consumed by static-site
# generators and other Markdown-to-HTML pipelines.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "Checking markdown files for lang front matter..."
echo "=================================================="

EXIT_CODE=0
CHECKED=0
MISSING=0

# Find all markdown files (excluding .git and node_modules)
while IFS= read -r -d '' file; do
    CHECKED=$((CHECKED + 1))
    REL_PATH="${file#$REPO_ROOT/}"

    # Check if the file has YAML front matter with a lang key.
    # Front matter must appear at the very beginning of the file between --- delimiters.
    if awk '
        BEGIN { in_fm=0; found=0 }
        NR==1 && /^---/ { in_fm=1; next }
        in_fm && /^---/ { exit }
        in_fm && /^lang:/ { found=1; exit }
        END { exit !found }
    ' "$file"; then
        echo "✅ Has lang: $REL_PATH"
    else
        echo "❌ Missing lang front matter: $REL_PATH"
        MISSING=$((MISSING + 1))
        EXIT_CODE=1
    fi
done < <(find "$REPO_ROOT" -name "*.md" -type f ! -path "*/\.git/*" ! -path "*/node_modules/*" -print0)

echo ""
echo "=================================================="
echo "Results: Checked $CHECKED files, $MISSING missing lang front matter"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All markdown files declare a document language!"
else
    echo "❌ Some markdown files are missing a lang front matter entry."
    echo ""
    echo "To fix: Add YAML front matter with a lang key at the top of each file."
    echo "Example:"
    echo "  ---"
    echo "  lang: en"
    echo "  ---"
    echo ""
    echo "This is required to satisfy the WCAG 2.1 / axe html-has-lang rule."
fi

exit $EXIT_CODE

#!/bin/bash
# Script to check that all markdown links have discernible text
# This helps prevent accessibility issues where links lack accessible names
# Addresses WCAG 2.1 Success Criterion 2.4.4 (Link Purpose) and axe rule: link-name

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "Checking markdown files for links with discernible text..."
echo "==========================================================="

EXIT_CODE=0
CHECKED=0
FILES_WITH_ISSUES=0

# Strip fenced code blocks and inline code from a file before checking
strip_code() {
    # Remove fenced code blocks (``` ... ``` and ~~~ ... ~~~) and inline code (`...`)
    python3 - "$1" <<'PYEOF'
import sys, re

with open(sys.argv[1], 'r', encoding='utf-8', errors='replace') as f:
    content = f.read()

# Remove fenced code blocks (``` or ~~~)
content = re.sub(r'```[\s\S]*?```', '', content)
content = re.sub(r'~~~[\s\S]*?~~~', '', content)

# Remove inline code (`...`)
content = re.sub(r'`[^`\n]+`', '', content)

# Print line numbers preserved for reporting
for i, line in enumerate(content.splitlines(), 1):
    print(f"{i}:{line}")
PYEOF
}

# Find all markdown files (excluding .git directory and node_modules)
while IFS= read -r -d '' file; do
    CHECKED=$((CHECKED + 1))
    REL_PATH="${file#$REPO_ROOT/}"
    FILE_ISSUES=0

    # Strip code blocks, then check for accessibility issues
    stripped=$(strip_code "$file")

    # Check for empty link text: [](...) or [   ](...)
    # Pattern: opening bracket, optional whitespace only, closing bracket, then (
    empty_links=$(echo "$stripped" | grep -P '\[\s*\]\s*\(' || true)
    if [ -n "$empty_links" ]; then
        echo "❌ $REL_PATH: contains links with empty text [](...)"
        echo "$empty_links" | while IFS= read -r line; do
            echo "   Line: $line"
        done
        FILE_ISSUES=$((FILE_ISSUES + 1))
        EXIT_CODE=1
    fi

    # Check for image-only links without alt text: [![](img)](url) or [![  ](img)](url)
    # Pattern: image link where the image itself has no or whitespace-only alt text
    empty_img_links=$(echo "$stripped" | grep -P '\[!\[\s*\]\s*\(' || true)
    if [ -n "$empty_img_links" ]; then
        echo "❌ $REL_PATH: contains image links with empty alt text [![](img)](url)"
        echo "$empty_img_links" | while IFS= read -r line; do
            echo "   Line: $line"
        done
        FILE_ISSUES=$((FILE_ISSUES + 1))
        EXIT_CODE=1
    fi

    if [ $FILE_ISSUES -eq 0 ]; then
        echo "✅ $REL_PATH"
    else
        FILES_WITH_ISSUES=$((FILES_WITH_ISSUES + 1))
    fi
done < <(find "$REPO_ROOT" -name "*.md" -type f ! -path "*/\.git/*" ! -path "*/node_modules/*" -print0)

echo ""
echo "==========================================================="
echo "Results: Checked $CHECKED files, $FILES_WITH_ISSUES files with link-name issues"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All markdown links have discernible text!"
else
    echo "❌ Some markdown files contain links without discernible text."
    echo ""
    echo "To fix: Ensure every link has visible text inside the brackets."
    echo "  Bad:  [](https://example.com)"
    echo "  Good: [Example Site](https://example.com)"
    echo ""
    echo "For image links, add alt text to the image:"
    echo "  Bad:  [![](image.png)](https://example.com)"
    echo "  Good: [![Descriptive alt text](image.png)](https://example.com)"
    echo ""
    echo "This is required for WCAG 2.1 accessibility compliance (SC 2.4.4 Link Purpose)."
fi

exit $EXIT_CODE
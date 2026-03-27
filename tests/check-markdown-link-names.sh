#!/bin/bash
# Test script to check markdown files for links with discernible text
# Flags links where the link text is a bare URL (e.g., [https://example.com](https://example.com))
# This ensures WCAG 2.1 / axe link-name compliance: links must have discernible text
# See: https://dequeuniversity.com/rules/axe/4.11/link-name

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

echo "Checking markdown files for links with discernible text..."
echo "==========================================================="
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

    # Detect links where link text is a bare URL: [http(s)://...](...)
    # A bare-URL link looks like: [https://example.com](https://example.com)
    # Skip content inside backtick code spans and code fences to avoid false positives
    bare_url_links=$(grep -nP '\[https?://[^\]]+\]\(https?://' "$file" 2>/dev/null \
        | grep -v '```' \
        | grep -v '`\[https\?://' \
        || true)

    if [[ -n "$bare_url_links" ]]; then
        echo "❌ $file"
        echo "   Links with bare URL as text (not accessible):"
        while IFS= read -r line; do
            echo "     $line"
        done <<< "$bare_url_links"
        echo "   Fix: Replace the link text with a descriptive label."
        echo "   Example: [Descriptive Title](https://example.com)"
        EXIT_CODE=1
    else
        echo "✅ $file"
        FILES_PASSED=$((FILES_PASSED + 1))
    fi
done < <(find . -name "*.md" -type f -print0 | grep -zv ".git")

echo ""
echo "==========================================================="
echo "Summary: $FILES_PASSED/$FILES_CHECKED files have no bare-URL link text"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All markdown links have discernible text"
else
    echo "❌ Some markdown links use bare URLs as link text"
    echo ""
    echo "To fix: Replace bare URL link text with a descriptive label."
    echo "Example: Change [https://example.com](https://example.com)"
    echo "     to: [Example Site](https://example.com)"
fi

exit $EXIT_CODE

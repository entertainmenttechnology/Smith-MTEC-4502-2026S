#!/bin/bash
# Test script to check markdown files for link accessibility issues (WCAG 2.1 link-in-text-block)
# This ensures links in text blocks are distinguishable without relying solely on color.
#
# Checks for:
# 1. Raw HTML <a> tags in markdown with inline color styling on surrounding text
#    (e.g., <span style="color:gray"><a href="...">link</a></span>)
# 2. Raw HTML <a> tags without visible text content (empty links)
#
# NOTE: Standard GFM links ([text](url)) rendered by GitHub automatically include
# underlines in prose/body contexts, so they naturally satisfy this requirement.
# This script focuses on raw HTML in markdown which bypasses GitHub's default styling.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

echo "Checking markdown files for link-in-text-block accessibility issues..."
echo "======================================================================"
echo ""

EXIT_CODE=0
FILES_CHECKED=0
FILES_PASSED=0

check_file_links() {
    local file="$1"
    local file_ok=0

    # Check for HTML <a> tags inside color-styled spans (gray text with link = contrast issue)
    # Pattern: <span with color style containing gray-range hex or named gray color> ... <a
    local gray_span_pattern
    gray_span_pattern='<span[^>]+style[^>]*color[^>]*>'
    if grep -qiE "$gray_span_pattern" "$file" 2>/dev/null; then
        # Check if any of those spans also contain <a tags
        if grep -iE "$gray_span_pattern" "$file" 2>/dev/null | grep -qi '<a '; then
            echo "  FAIL: Found link inside a styled span - check for gray text context"
            echo "        Links in colored text blocks may fail WCAG link-in-text-block rule"
            grep -niE "$gray_span_pattern" "$file" 2>/dev/null | grep -i '<a ' | head -3
            file_ok=1
            EXIT_CODE=1
        fi
    fi

    # Check for raw HTML <a> tags that have no text content (empty link text)
    # These fail both link-name and link-in-text-block rules
    if grep -qiE '<a [^>]*href[^>]*>[[:space:]]*</a>' "$file" 2>/dev/null; then
        echo "  FAIL: Found empty link (no visible text) - fails link-name rule"
        grep -niE '<a [^>]*href[^>]*>[[:space:]]*</a>' "$file" 2>/dev/null | head -3
        file_ok=1
        EXIT_CODE=1
    fi

    return $file_ok
}

while IFS= read -r -d '' file; do
    # Skip hidden directories (like .git)
    if [[ "$file" == *"/.git/"* ]]; then
        continue
    fi

    FILES_CHECKED=$((FILES_CHECKED + 1))
    rel_path="${file#$REPO_ROOT/}"
    echo "Checking: $rel_path"

    file_result=0
    check_file_links "$file" || file_result=$?

    if [ $file_result -eq 0 ]; then
        echo "  OK: No link-in-text-block issues found"
        FILES_PASSED=$((FILES_PASSED + 1))
    fi
    echo ""
done < <(find . -path '*/.git/*' -prune -o -name "*.md" -type f -print0)

echo "======================================================================"
echo "Summary: $FILES_PASSED/$FILES_CHECKED files passed link accessibility check"
echo ""

if [ $EXIT_CODE -eq 0 ]; then
    echo "PASS: No link-in-text-block accessibility issues found in markdown content"
    echo ""
    echo "Note: Standard GFM links ([text](url)) render with underlines on GitHub, satisfying"
    echo "WCAG 2.1 link-in-text-block requirements. If the GitHub accessibility scanner flags"
    echo "a '<a href=\"/login\">Signing in</a>' element, this is GitHub's own UI element (not"
    echo "markdown content) and requires the scanner to run as an authenticated GitHub user."
    echo "See .github/workflows/accessibility-scan.yml for authentication configuration."
else
    echo "FAIL: Some markdown files have potential link-in-text-block accessibility issues"
    echo ""
    echo "To fix: Ensure links within text blocks are visually distinguishable from surrounding"
    echo "text without relying on color alone. Options:"
    echo "  1. Use standard GFM links ([text](url)) which render with underlines on GitHub"
    echo "  2. Avoid placing HTML <a> tags inside color-styled <span> elements"
    echo "  3. Ensure all HTML <a> tags have visible, non-empty link text"
fi

exit $EXIT_CODE

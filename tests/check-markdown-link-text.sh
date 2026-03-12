#!/bin/bash
# Test script to check that links in markdown files have discernible text
# Specifically validates resources/speculative_future_careers.md as reported in
# the accessibility issue: "Links must have discernible text"
#
# WCAG 2.1 Success Criterion 2.4.4 (Link Purpose) / axe rule: link-name

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TARGET_FILE="$REPO_ROOT/resources/speculative_future_careers.md"

echo "Checking links have discernible text in resources/speculative_future_careers.md..."
echo "=================================================================================="
echo ""

ISSUES=0

# Verify target file exists
if [ ! -f "$TARGET_FILE" ]; then
    echo "❌ File not found: resources/speculative_future_careers.md"
    exit 1
fi

# Check for empty link text [](url) or whitespace-only [   ](url)
while IFS= read -r line_info; do
    lineno="${line_info%%:*}"
    content="${line_info#*:}"

    if echo "$content" | grep -qP '(?<!\!)\[\s*\]\('; then
        echo "❌ Line $lineno: link with empty text — '$content'"
        ISSUES=$((ISSUES + 1))
    fi

    if echo "$content" | grep -qP '\[!\[\s*\]\([^)]*\)\]\('; then
        echo "❌ Line $lineno: image link with empty alt text — '$content'"
        ISSUES=$((ISSUES + 1))
    fi
done < <(grep -nP '\[[^\]]*\]\(' "$TARGET_FILE" 2>/dev/null || true)

echo ""
if [ "$ISSUES" -eq 0 ]; then
    echo "✅ resources/speculative_future_careers.md — all links have discernible text"
    exit 0
else
    echo "❌ Found $ISSUES link-text accessibility issue(s) in resources/speculative_future_careers.md"
    echo ""
    echo "Every link must have non-empty, meaningful text so screen readers can describe it."
    echo "See: https://dequeuniversity.com/rules/axe/4.11/link-name"
    exit 1
fi

#!/bin/bash
# Test script to verify README.md (and all markdown files) do not contain
# raw HTML block elements outside of landmark regions.
#
# WCAG 2.1 / axe rule: region
# All page content should be contained by landmarks (main, nav, header, footer,
# aside, section with aria-label, etc.).
#
# For Markdown files rendered by GitHub, all content is placed inside GitHub's
# <main> element (a landmark), so the content is automatically compliant as long
# as no raw HTML block elements are injected outside the rendered content area.
#
# This test verifies that markdown files:
#   1. Do NOT contain raw HTML block elements that could appear outside landmarks
#   2. Are pure Markdown (or use only landmark-safe inline HTML)
#
# Reference: https://dequeuniversity.com/rules/axe/4.11/region

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

echo "Checking markdown files for landmark/region accessibility compliance..."
echo "========================================================================"
echo ""

EXIT_CODE=0
FILES_CHECKED=0
FILES_PASSED=0

# HTML block-level elements that, if present outside a landmark wrapper, would
# violate the 'region' axe rule.  We flag any that appear at the start of a
# line (i.e., acting as block elements) without being wrapped in a landmark.
# Note: inline elements like <span> are excluded intentionally.
PROBLEMATIC_ELEMENTS="div|p|table|ul|ol|li|h[1-6]|blockquote|pre|figure|figcaption|details|summary"

while IFS= read -r -d '' file; do
    FILES_CHECKED=$((FILES_CHECKED + 1))
    FILE_FAILED=0
    IN_CODE_FENCE=0

    # Read each line and detect raw HTML block elements that are not wrapped in
    # a landmark region.  Code-fenced content is skipped entirely.
    while IFS= read -r line; do
        # Toggle code fence state
        if echo "$line" | grep -qE "^\s*\`\`\`"; then
            if [ "$IN_CODE_FENCE" -eq 0 ]; then
                IN_CODE_FENCE=1
            else
                IN_CODE_FENCE=0
            fi
            continue
        fi

        # Skip lines inside a code fence
        [ "$IN_CODE_FENCE" -eq 1 ] && continue

        # Skip HTML comment lines
        echo "$line" | grep -qE "^\s*<!--" && continue

        # Check if line starts with a raw block-level HTML element
        if echo "$line" | grep -qiE "^[<]($PROBLEMATIC_ELEMENTS)([ \t\r\n]|>|/)"; then
            echo "❌ $file"
            echo "   Found raw HTML block element outside a landmark: ${line:0:80}"
            echo "   Wrap the content in a landmark element (e.g., <main>, <section>)"
            FILE_FAILED=1
            EXIT_CODE=1
            break
        fi
    done < "$file"

    if [ "$FILE_FAILED" -eq 0 ]; then
        echo "✅ $file"
        FILES_PASSED=$((FILES_PASSED + 1))
    fi

done < <(find . -name "*.md" -type f ! -path "./.git/*" -print0)

echo ""
echo "========================================================================"
echo "Summary: $FILES_PASSED/$FILES_CHECKED files pass landmark/region check"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All markdown files pass the landmark/region accessibility check"
    echo ""
    echo "Note: Pure Markdown content is rendered inside GitHub's <main> element,"
    echo "satisfying the WCAG 2.1 'region' (axe) rule automatically."
else
    echo "❌ Some markdown files contain HTML block elements outside landmark regions"
    echo ""
    echo "To fix: Wrap raw HTML block elements in a landmark element, e.g.:"
    echo "  <main>"
    echo "    <h1>Page Title</h1>"
    echo "    ..."
    echo "  </main>"
fi

exit $EXIT_CODE

#!/bin/bash
# Test script to check markdown files for "region" landmark accessibility compliance
# Validates that all content is organized within heading-based regions (WCAG 2.1)
# This corresponds to the axe rule: https://dequeuniversity.com/rules/axe/4.11/region
#
# For markdown files rendered on GitHub, all content is wrapped in HTML5 <main> landmark.
# This script checks that no content appears before the first H1 heading, ensuring
# the document structure aligns with proper landmark-based content organization.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

echo "Checking markdown files for region/landmark accessibility compliance..."
echo "========================================================================"
echo "Rule: All content should be contained within heading-based regions"
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

    # Check 1: File must have at least one H1 heading anywhere in the file
    has_h1=false
    if grep -q "^# " "$file"; then
        has_h1=true
    fi

    # Check 2: No non-empty, non-comment content should appear before the first heading
    # This ensures content is within the H1 landmark region
    content_before_heading=false
    while IFS= read -r line; do
        # Stop at first heading (any level)
        if [[ "$line" =~ ^#{1,6}[[:space:]] ]]; then
            break
        fi
        # Skip empty lines and HTML comments
        if [[ -z "$line" ]] || [[ "$line" =~ ^[[:space:]]*$ ]] || [[ "$line" =~ ^\<\!\-\- ]]; then
            continue
        fi
        # Non-empty content found before first heading
        content_before_heading=true
        break
    done < "$file"

    # Check 3: (Future) Detect raw HTML block-level elements without ARIA landmarks
    # TODO: Add check for embedded HTML that could create content outside landmark regions

    if $has_h1 && ! $content_before_heading; then
        echo "✅ $file"
        FILES_PASSED=$((FILES_PASSED + 1))
    else
        echo "❌ $file"
        if ! $has_h1; then
            echo "   Missing H1 heading — content has no main landmark region anchor"
        fi
        if $content_before_heading; then
            echo "   Content found before first heading — may appear outside landmark regions"
        fi
        EXIT_CODE=1
    fi
done < <(find . -name "*.md" -type f -print0 | grep -zv ".git")

echo ""
echo "========================================================================"
echo "Summary: $FILES_PASSED/$FILES_CHECKED files pass region/landmark check"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All markdown files pass region/landmark accessibility check"
else
    echo "❌ Some markdown files have region/landmark accessibility issues"
    echo ""
    echo "To fix:"
    echo "  1. Add a level-one heading (# Title) as the first content in the file"
    echo "  2. Ensure no text content appears before the first heading"
    echo "  Reference: https://dequeuniversity.com/rules/axe/4.11/region"
fi

exit $EXIT_CODE

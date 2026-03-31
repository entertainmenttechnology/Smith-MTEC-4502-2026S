#!/bin/bash
# Test script to check markdown files for links with discernible text
# This ensures WCAG 2.1 compliance by validating that links have accessible text
# Checks for both HTML anchor tags and markdown links without discernible text
# Note: Lines inside fenced code blocks (``` or ~~~) are skipped.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

echo "Checking markdown files for links with discernible text..."
echo "============================================================"
echo ""

EXIT_CODE=0
FILES_CHECKED=0
VIOLATIONS=0

while IFS= read -r -d '' file; do
    # Skip hidden directories (like .git)
    if [[ "$file" == *"/.git/"* ]]; then
        continue
    fi

    FILES_CHECKED=$((FILES_CHECKED + 1))
    file_has_violation=false
    in_code_block=false

    while IFS= read -r line; do
        # Toggle fenced code block state (``` or ~~~)
        if echo "$line" | grep -qP '^(```|~~~)'; then
            if $in_code_block; then
                in_code_block=false
            else
                in_code_block=true
            fi
            continue
        fi

        # Skip lines inside code blocks
        if $in_code_block; then
            continue
        fi

        # Skip lines that are inline code (start with 4 spaces or a tab — indented code blocks)
        if echo "$line" | grep -qP '^(    |\t)'; then
            continue
        fi

        # Strip inline code spans (single and double backtick-quoted text) before checking
        # This prevents code examples like `<a href="..."></a>` or ``code`` from being flagged
        stripped_line=$(echo "$line" | sed 's/``[^`]*``//g; s/`[^`]*`//g')
        if echo "$stripped_line" | grep -qP '<a\s[^>]*>\s*</a>'; then
            if ! $file_has_violation; then
                echo "❌ $file"
                file_has_violation=true
                EXIT_CODE=1
            fi
            echo "   Empty HTML link: $line"
            VIOLATIONS=$((VIOLATIONS + 1))
        fi

        # Check for HTML anchor tag with only an image (no alt text) and no aria-label/title
        # Pattern allows optional whitespace around the = sign for alt attribute
        if echo "$stripped_line" | grep -qP '<a\s[^>]*>\s*<img\s[^>]*alt\s*=\s*["'"'"']\s*["'"'"'][^>]*>\s*</a>'; then
            if ! $file_has_violation; then
                echo "❌ $file"
                file_has_violation=true
                EXIT_CODE=1
            fi
            echo "   Link contains image with empty alt text: $line"
            VIOLATIONS=$((VIOLATIONS + 1))
        fi

        # Check for markdown links with empty text: [](url)
        # Uses a word boundary approach: not preceded by '!' (image syntax uses ![alt](url))
        # Task checkboxes like "- [ ] item" have no URL so they are not matched by [^)]+ requirement
        if echo "$stripped_line" | grep -qP '(^|[^!])\[\s*\]\([^)]+\)'; then
            if ! $file_has_violation; then
                echo "❌ $file"
                file_has_violation=true
                EXIT_CODE=1
            fi
            echo "   Markdown link with no text: $line"
            VIOLATIONS=$((VIOLATIONS + 1))
        fi
    done < "$file"

    if ! $file_has_violation; then
        echo "✅ $file"
    fi
done < <(find . -name "*.md" -type f -print0 | grep -zv ".git")

echo ""
echo "============================================================"
echo "Summary: Checked $FILES_CHECKED files, found $VIOLATIONS link accessibility violations"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All links in markdown files have discernible text"
else
    echo "❌ Some links are missing discernible text"
    echo ""
    echo "To fix:"
    echo "  - For markdown links: use [descriptive text](url) instead of [](url)"
    echo "  - For HTML anchor tags: add visible text, aria-label, or title attribute"
    echo "  - For image-only links: add non-empty alt text to the image, or add aria-label to the anchor"
    echo ""
    echo "See WCAG 2.1 Success Criterion 2.4.4 (Link Purpose)"
    echo "Reference: https://dequeuniversity.com/rules/axe/4.11/link-name"
fi

exit $EXIT_CODE

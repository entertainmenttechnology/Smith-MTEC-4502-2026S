#!/bin/bash
# Test script to check markdown files for accessible link patterns
# Ensures links in markdown files meet WCAG 2.1 SC 1.4.1 (Use of Color) requirements
# by verifying link text is descriptive and not empty/non-meaningful

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

echo "Checking markdown files for accessible link patterns..."
echo "========================================================"
echo ""

EXIT_CODE=0
FILES_CHECKED=0
LINKS_CHECKED=0
LINKS_FAILED=0

# Non-descriptive link texts that indicate accessibility problems
NON_DESCRIPTIVE_PATTERNS=(
    "^click here$"
    "^here$"
    "^read more$"
    "^more$"
    "^link$"
    "^this$"
    "^[[:space:]]*$"
)

while IFS= read -r -d '' file; do
    # Skip hidden directories (like .git)
    if [[ "$file" == *"/.git/"* ]]; then
        continue
    fi

    FILES_CHECKED=$((FILES_CHECKED + 1))
    FILE_FAILED=0

    # Regex pattern for markdown links: [text](url) - captures empty text too
    LINK_PATTERN='\[[^]]*\]\([^)]+\)'

    # Extract all markdown links: [text](url)
    while IFS= read -r match; do
        LINKS_CHECKED=$((LINKS_CHECKED + 1))

        # Extract the link text (content between [ and ]) using non-greedy character class
        link_text=$(echo "$match" | sed 's/\[\([^]]*\)\](.*/\1/')

        # Check for empty link text
        if [[ -z "${link_text// }" ]]; then
            echo "❌ $file"
            echo "   Empty link text found: $match"
            echo "   Empty link text violates WCAG 2.1 (links must have descriptive text)"
            FILE_FAILED=1
            LINKS_FAILED=$((LINKS_FAILED + 1))
            continue
        fi

        # Check for non-descriptive link text (case-insensitive)
        lower_text=$(echo "$link_text" | tr '[:upper:]' '[:lower:]' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
        IS_NON_DESCRIPTIVE=0
        for pattern in "${NON_DESCRIPTIVE_PATTERNS[@]}"; do
            if echo "$lower_text" | grep -qiE "$pattern"; then
                IS_NON_DESCRIPTIVE=1
                break
            fi
        done

        if [ $IS_NON_DESCRIPTIVE -eq 1 ]; then
            echo "❌ $file"
            echo "   Non-descriptive link text: '$link_text'"
            echo "   Use descriptive text that explains the link destination"
            FILE_FAILED=1
            LINKS_FAILED=$((LINKS_FAILED + 1))
        fi
    done < <(grep -oE "$LINK_PATTERN" "$file" 2>/dev/null || true)

    if [ $FILE_FAILED -eq 0 ]; then
        # Only print success if file has links or explicitly note no links
        link_count=$(grep -oE "$LINK_PATTERN" "$file" 2>/dev/null | wc -l | tr -d '[:space:]')
        if [ "${link_count:-0}" -gt 0 ]; then
            echo "✅ $file ($link_count link(s) with descriptive text)"
        else
            echo "✅ $file (no links)"
        fi
    else
        EXIT_CODE=1
    fi
done < <(find . -name "*.md" -type f -print0 | grep -zv ".git")

echo ""
echo "========================================================"
echo "Summary: Checked $FILES_CHECKED files, $LINKS_CHECKED link(s) found, $LINKS_FAILED issue(s) found"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All markdown links meet accessibility requirements"
else
    echo "❌ Some markdown links have accessibility issues"
    echo ""
    echo "To fix:"
    echo "  - Replace empty or non-descriptive link text (e.g. 'click here', 'here')"
    echo "  - Use descriptive text that explains where the link goes"
    echo "  - Example: [View the accessibility guidelines](https://www.w3.org/WAI/WCAG21/)"
    echo ""
    echo "WCAG 2.1 Reference: https://www.w3.org/WAI/WCAG21/Understanding/link-purpose-in-context"
fi

exit $EXIT_CODE

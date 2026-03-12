#!/bin/bash
# Specific test for resources/speculative_future_careers.md accessibility
# Verifies that all links in the file use descriptive text (WCAG 2.1 SC 1.4.1, SC 2.4.4)
# Links must be distinguishable without relying on color alone

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

FILE="resources/speculative_future_careers.md"
FULL_PATH="$REPO_ROOT/$FILE"

echo "Testing $FILE for accessible link patterns..."
echo "=================================================="

if [ ! -f "$FULL_PATH" ]; then
    echo "❌ File not found: $FILE"
    exit 1
fi

EXIT_CODE=0
LINKS_FOUND=0
LINKS_FAILED=0

# Non-descriptive link texts that would fail WCAG 2.1 SC 2.4.4
NON_DESCRIPTIVE_PATTERNS=(
    "^click here$"
    "^here$"
    "^read more$"
    "^more$"
    "^link$"
    "^this$"
    "^[[:space:]]*$"
)

# Check for markdown links [text](url) - pattern captures empty text too
LINK_PATTERN='\[[^]]*\]\([^)]+\)'

while IFS= read -r match; do
    LINKS_FOUND=$((LINKS_FOUND + 1))

    # Extract the link text using non-greedy character class
    link_text=$(echo "$match" | sed 's/\[\([^]]*\)\](.*/\1/')

    # Check for empty link text
    if [[ -z "${link_text// }" ]]; then
        echo "❌ Empty link text found: $match"
        echo "   Links must have descriptive text (WCAG 2.1 SC 2.4.4)"
        LINKS_FAILED=$((LINKS_FAILED + 1))
        EXIT_CODE=1
        continue
    fi

    # Check for non-descriptive link text
    lower_text=$(echo "$link_text" | tr '[:upper:]' '[:lower:]' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    IS_NON_DESCRIPTIVE=0
    for pattern in "${NON_DESCRIPTIVE_PATTERNS[@]}"; do
        if echo "$lower_text" | grep -qiE "$pattern"; then
            IS_NON_DESCRIPTIVE=1
            break
        fi
    done

    if [ $IS_NON_DESCRIPTIVE -eq 1 ]; then
        echo "❌ Non-descriptive link text: '$link_text'"
        echo "   Links must use descriptive text to be distinguishable (WCAG 2.1 SC 1.4.1, SC 2.4.4)"
        LINKS_FAILED=$((LINKS_FAILED + 1))
        EXIT_CODE=1
    else
        echo "✅ Accessible link text: '$link_text'"
    fi
done < <(grep -oE "$LINK_PATTERN" "$FULL_PATH" 2>/dev/null || true)

echo ""
echo "=================================================="

if [ $LINKS_FOUND -eq 0 ]; then
    echo "✅ $FILE: No links found - no link accessibility issues"
    echo "   Note: When links are added, ensure they meet WCAG 2.1 requirements:"
    echo "   - Use descriptive link text (not 'click here', 'here', etc.)"
    echo "   - Ensure links are visually distinguishable from surrounding text"
    echo "     via underline, bold, or sufficient color contrast (3:1 minimum)"
elif [ $EXIT_CODE -eq 0 ]; then
    echo "✅ $FILE: All $LINKS_FOUND link(s) have accessible, descriptive text"
else
    echo "❌ $FILE: $LINKS_FAILED of $LINKS_FOUND link(s) have accessibility issues"
    echo ""
    echo "To fix: Replace non-descriptive link text with text describing the destination."
    echo "Example: Change '[click here](url)' to '[WCAG 2.1 Guidelines](url)'"
fi

exit $EXIT_CODE

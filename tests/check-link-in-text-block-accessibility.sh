#!/bin/bash
# Test script to check links embedded in markdown paragraph text for accessibility compliance
# Addresses WCAG 2.1 / axe rule: link-in-text-block
# Links in text blocks must be distinguishable without relying on color alone.
# This is achieved when link anchor text is descriptive (not generic like "here" or "click here"),
# which ensures users can identify and distinguish links by their meaningful text content.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

echo "Checking markdown links in text blocks for accessibility compliance (link-in-text-block)..."
echo "========================================================================================="
echo ""

# Generic/non-descriptive anchor text patterns that violate WCAG 2.4.4 Link Purpose
GENERIC_PATTERNS=(
    "^here$"
    "^click here$"
    "^read more$"
    "^more$"
    "^link$"
    "^this$"
    "^page$"
    "^url$"
    "^website$"
    "^learn more$"
    "^details$"
    "^info$"
    "^information$"
    "^continue$"
    "^go$"
    "^\.\.\.$"
)

EXIT_CODE=0
FILES_CHECKED=0
LINKS_CHECKED=0
VIOLATIONS=0

while IFS= read -r -d '' file; do
    # Skip hidden directories (like .git)
    if [[ "$file" == *"/.git/"* ]]; then
        continue
    fi

    FILES_CHECKED=$((FILES_CHECKED + 1))
    IN_CODE_BLOCK=0

    while IFS= read -r line; do
        # Toggle code block state on fenced code block markers
        if [[ "$line" =~ ^(\`\`\`|~~~) ]]; then
            if [ $IN_CODE_BLOCK -eq 0 ]; then
                IN_CODE_BLOCK=1
            else
                IN_CODE_BLOCK=0
            fi
            continue
        fi

        # Skip lines inside code blocks, headings, list items, and blank lines
        if [ $IN_CODE_BLOCK -eq 1 ]; then
            continue
        fi
        if [[ "$line" =~ ^[[:space:]]*$ ]]; then
            continue
        fi
        if [[ "$line" =~ ^[[:space:]]*#+ ]]; then
            continue
        fi
        # Skip list items (ordered and unordered)
        if [[ "$line" =~ ^[[:space:]]*[-*+][[:space:]] || "$line" =~ ^[[:space:]]*[0-9]+\.[[:space:]] ]]; then
            continue
        fi
        # Skip lines that are only a link (standalone link lines are acceptable)
        stripped="${line#"${line%%[![:space:]]*}"}"
        if [[ "$stripped" =~ ^\[.+\]\(.+\)[[:space:]]*$ ]]; then
            continue
        fi

        # Find inline markdown links [text](url) in paragraph lines
        remaining="$line"
        while [[ "$remaining" =~ \[([^\]]+)\]\([^\)]+\) ]]; do
            anchor_text="${BASH_REMATCH[1]}"
            # Remove leading/trailing whitespace and markdown formatting (* _ ` ** __)
            anchor_clean=$(echo "$anchor_text" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//;s/\*//g;s/_//g;s/`//g')
            anchor_lower=$(echo "$anchor_clean" | tr '[:upper:]' '[:lower:]')

            LINKS_CHECKED=$((LINKS_CHECKED + 1))

            is_generic=0
            for pattern in "${GENERIC_PATTERNS[@]}"; do
                if echo "$anchor_lower" | grep -qE "$pattern"; then
                    is_generic=1
                    break
                fi
            done

            if [ $is_generic -eq 1 ]; then
                echo "❌ $file"
                echo "   Non-descriptive link anchor text: \"$anchor_text\""
                echo "   Context: ${line:0:120}"
                echo "   Fix: Use descriptive anchor text that makes sense out of context"
                echo "   Reference: https://dequeuniversity.com/rules/axe/4.11/link-in-text-block"
                VIOLATIONS=$((VIOLATIONS + 1))
                EXIT_CODE=1
            fi

            # Advance past this match to find subsequent links on the same line
            remaining="${remaining#*"${BASH_REMATCH[0]}"}"
        done
    done < "$file"
done < <(find . -name "*.md" -type f -print0 | grep -zv ".git")

echo ""
echo "========================================================================================="
echo "Summary: Checked $LINKS_CHECKED inline links across $FILES_CHECKED markdown files"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All inline links in text blocks have descriptive anchor text"
else
    echo "❌ Found $VIOLATIONS link(s) with non-descriptive anchor text"
    echo ""
    echo "To fix: Replace generic anchor text (e.g. 'here', 'click here', 'read more') with"
    echo "        descriptive text that identifies the link destination or purpose."
    echo "Example: Instead of 'See [here](guide.md) for details'"
    echo "         use    'See the [accessibility guide](guide.md) for details'"
fi

exit $EXIT_CODE

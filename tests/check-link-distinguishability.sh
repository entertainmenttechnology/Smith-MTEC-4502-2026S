#!/bin/bash
# Test script to check that inline links in markdown files have distinguishing formatting
# beyond color (e.g., bold text wrapping) to meet WCAG 2.1 link-in-text-block requirements.
#
# WCAG 2.1 requires that links within a block of text are distinguishable
# from the surrounding text in a way that does not rely solely on color.
# See: https://dequeuniversity.com/rules/axe/4.11/link-in-text-block

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

echo "Checking markdown files for distinguishable inline links..."
echo "=========================================================="
echo "WCAG 2.1 requires links in text blocks to be distinguishable"
echo "by more than just color (e.g., bold formatting, standalone line)."
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
    FILE_VIOLATIONS=0

    # Read file line by line, tracking code block state
    line_num=0
    in_code_block=0
    while IFS= read -r line; do
        line_num=$((line_num + 1))

        # Track fenced code blocks (``` or ~~~) - skip lines inside them
        if echo "$line" | grep -qE '^[[:space:]]*(```|~~~)'; then
            if [ $in_code_block -eq 0 ]; then
                in_code_block=1
            else
                in_code_block=0
            fi
            continue
        fi
        # Skip lines inside code blocks
        [ $in_code_block -eq 1 ] && continue

        # Skip indented code blocks (4+ spaces or tab at start)
        if echo "$line" | grep -qE '^([[:space:]]{4}|\t)'; then
            continue
        fi

        # Skip blank lines
        [[ -z "${line// }" ]] && continue
        # Skip headings (start with #)
        [[ "$line" =~ ^[[:space:]]*# ]] && continue
        # Skip horizontal rules
        [[ "$line" =~ ^[[:space:]]*---+[[:space:]]*$ ]] && continue
        # Skip table rows (contains | characters)
        [[ "$line" =~ ^\|.*\| ]] && continue

        # Check if line contains an inline markdown link [text](url)
        if echo "$line" | grep -qE '\[.+\]\(https?://[^)]+\)'; then
            # Check if the link has distinguishing formatting:
            # 1. Link wrapped in bold: **[text](url)** or **...[text](url)...**
            # 2. Link wrapped in italic: _[text](url)_ or *[text](url)*
            # 3. Line starts with the link (standalone / not inline text)
            # 4. Link is in a list item that is standalone (bullet + link only)
            # 5. Line is only a link (possibly with emoji prefix like 👉)

            # Extract links from this line and check each
            while IFS= read -r link_match; do
                # Check if this specific link has bold/italic formatting around it
                # Pattern: **[text](url)** - bold wraps the link directly
                if echo "$line" | grep -qE '\*\*\[.+\]\(https?://[^)]+\)\*\*'; then
                    continue  # Link is bold - distinguishable
                fi
                # Pattern: _[text](url)_ - italic wraps the link with underscores
                if echo "$line" | grep -qE '_\[.+\]\(https?://[^)]+\)_'; then
                    continue  # Link is italic (underscore) - distinguishable
                fi
                # Pattern: *[text](url)* - italic wraps the link with asterisks
                if echo "$line" | grep -qE '\*\[.+\]\(https?://[^)]+\)\*'; then
                    continue  # Link is italic (asterisk) - distinguishable
                fi
                # Pattern: Line that starts with optional emoji/bullet and contains only a link
                # e.g., "👉 **[text](url)**" or "- [text](url)" as standalone list
                if echo "$line" | grep -qE '^[[:space:]]*([-*+>]|[0-9]+\.|[[:space:]]|[[:punct:]])*\[.+\]\(https?://[^)]+\)[[:space:]]*$'; then
                    continue  # Link is standalone on the line - distinguishable
                fi
                # Pattern: Link is the entire content of a line (maybe with trailing spaces)
                stripped="${line//[[:space:]]/}"
                if [[ "$stripped" =~ ^\[.+\]\(https?:// ]]; then
                    continue  # Link is standalone - distinguishable
                fi

                # If we get here, this might be an inline link only distinguished by color
                # Check if line has substantial surrounding text (more than just the link)
                # Remove the link from the line and check if there's surrounding text
                surrounding=$(echo "$line" | sed 's/\[.*\]([^)]*)//g')
                surrounding_trimmed="${surrounding// /}"
                surrounding_trimmed="${surrounding_trimmed//	/}"
                # If there's substantial surrounding text, this is a concern
                if [[ ${#surrounding_trimmed} -gt 10 ]]; then
                    echo "⚠️  Potential violation in: $file"
                    echo "   Line $line_num: Inline link may only be distinguished by color"
                    echo "   Text: ${line:0:120}"
                    echo "   Fix: Wrap link in bold (**[text](url)**) or make it standalone"
                    echo ""
                    FILE_VIOLATIONS=$((FILE_VIOLATIONS + 1))
                    VIOLATIONS=$((VIOLATIONS + 1))
                    EXIT_CODE=1
                fi
            done < <(echo "$line" | grep -oE '\[.+\]\(https?://[^)]+\)')
        fi
    done < "$file"

    if [ $FILE_VIOLATIONS -eq 0 ]; then
        echo "✅ $file"
    fi
done < <(find . -name "*.md" -type f -print0 | grep -zv ".git")

echo ""
echo "=========================================================="
echo "Summary: Checked $FILES_CHECKED files, found $VIOLATIONS potential violations"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All inline links appear to have distinguishing formatting"
else
    echo "❌ Some links may only be distinguished by color"
    echo ""
    echo "To fix: Ensure inline links in paragraph text use bold or italic formatting,"
    echo "or place them on their own line so they are distinguishable without color."
    echo "Example: Use **[Link Text](https://example.com)** instead of [Link Text](https://example.com)"
fi

exit $EXIT_CODE

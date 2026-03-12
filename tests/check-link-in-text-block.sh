#!/bin/bash
# Test script to check that inline links in markdown files are not embedded
# within plain text paragraphs in a way that could be indistinguishable from
# surrounding text without relying on color alone.
#
# This helps prevent WCAG 2.1 / axe 'link-in-text-block' violations where
# a link cannot be told apart from surrounding text except by its color.
#
# Rule reference: https://dequeuniversity.com/rules/axe/4.11/link-in-text-block

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

TARGET_FILE="${1:-}"   # Optional: pass a specific file to check

cd "$REPO_ROOT"

echo "Checking markdown files for inline links in text blocks..."
echo "============================================================"
echo ""

EXIT_CODE=0
FILES_CHECKED=0
FILES_WITH_INLINE_LINKS=0

# Pattern for markdown inline links: [text](url)
# We flag any inline link that appears embedded in a non-empty prose paragraph
# (i.e. line that also has text before/after the link marker).
check_file() {
    local file="$1"
    FILES_CHECKED=$((FILES_CHECKED + 1))
    local found_issue=0

    # Read each line; detect lines that:
    #  - contain at least one markdown inline link [...](...) 
    #  - AND have surrounding text (not a standalone link line)
    while IFS= read -r line; do
        # Skip blank lines, headings, list-only lines, and table rows
        [[ -z "$line" ]] && continue
        [[ "$line" =~ ^[[:space:]]*#+ ]] && continue
        [[ "$line" =~ ^\|.*\|$ ]] && continue

        # Check if line contains a markdown inline link
        if echo "$line" | grep -qE '\[[^]]+\]\([^)]+\)'; then
            # Check that other non-link text also exists on the line
            # (i.e. the link is embedded in a paragraph, not a standalone link)
            # Use \( and \) to match literal parentheses in the sed BRE pattern
            stripped=$(echo "$line" | sed 's/\[[^]]*\](\([^)]*\))//g' | tr -d '[:space:]')
            if [[ -n "$stripped" ]]; then
                if [[ $found_issue -eq 0 ]]; then
                    echo "⚠️  $file"
                    echo "   Inline links found in text blocks (verify they are visually distinguishable"
                    echo "   from surrounding text without relying on color alone):"
                    found_issue=1
                    FILES_WITH_INLINE_LINKS=$((FILES_WITH_INLINE_LINKS + 1))
                fi
                echo "   Line: $(echo "$line" | cut -c1-100)"
            fi
        fi
    done < "$file"

    if [[ $found_issue -eq 0 ]]; then
        echo "✅ $file (no inline links in text blocks)"
    fi
}

if [[ -n "$TARGET_FILE" ]]; then
    if [[ ! -f "$TARGET_FILE" ]]; then
        echo "❌ File not found: $TARGET_FILE"
        exit 1
    fi
    check_file "$TARGET_FILE"
else
    while IFS= read -r -d '' file; do
        check_file "$file"
    done < <(find . -name "*.md" -type f ! -path "*/.git/*" -print0)
fi

echo ""
echo "============================================================"
echo "Summary: Checked $FILES_CHECKED files."
echo "         $FILES_WITH_INLINE_LINKS file(s) contain inline links in text blocks."

if [[ $FILES_WITH_INLINE_LINKS -gt 0 ]]; then
    echo ""
    echo "ℹ️  Action required for files with inline links in text blocks:"
    echo "   Ensure each link is visually distinguishable from surrounding text"
    echo "   WITHOUT relying on color alone. Options:"
    echo "     1. Place the link on its own line (not embedded in a paragraph)."
    echo "     2. Prefix with a label, e.g. 'See: [Link text](url)' on its own line."
    echo "     3. Where your rendering environment supports it, ensure links have"
    echo "        an underline or other non-color text decoration."
    echo ""
    echo "   WCAG 2.1 SC 1.4.1 requires non-color cues for distinguishing links."
    echo "   Reference: https://dequeuniversity.com/rules/axe/4.11/link-in-text-block"
fi

exit $EXIT_CODE

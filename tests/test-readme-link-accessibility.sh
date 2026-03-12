#!/bin/bash
# Test script to validate README.md links are accessible per WCAG 2.1 SC 1.4.1 (Use of Color)
# Ensures links in text blocks are distinguishable without relying on color alone.
# Axe rule: link-in-text-block
# Reference: https://dequeuniversity.com/rules/axe/4.11/link-in-text-block

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
FILE="$REPO_ROOT/README.md"
EXIT_CODE=0

echo "Testing README.md for link accessibility (WCAG 2.1 SC 1.4.1 - Use of Color)"
echo "============================================================================"
echo ""

if [ ! -f "$FILE" ]; then
    echo "❌ File not found: $FILE"
    exit 1
fi

# -----------------------------------------------------------------------
# Check 1: No bare URL links (link text must not be a raw URL)
# Bare URLs as link text provide no contextual distinction from surrounding
# text, violating the requirement to distinguish links without color alone.
# -----------------------------------------------------------------------
echo "Check 1: Links must have descriptive text (not bare URLs)..."
bare_url_links=$(grep -nE '\[https?://[^]]+\]\(' "$FILE" || true)
if [ -n "$bare_url_links" ]; then
    echo "❌ Found link(s) using raw URLs as link text:"
    echo "$bare_url_links"
    echo "   Fix: Replace bare URL link text with a descriptive label."
    EXIT_CODE=1
else
    echo "✅ All links use descriptive text (not bare URLs)"
fi

# -----------------------------------------------------------------------
# Check 2: Links in prose paragraphs must have non-color emphasis
# Inline links within regular paragraph text (lines that are not headings,
# list bullets, or code fences) should use **bold** or _italic_ emphasis
# so they are distinguishable from surrounding text without relying on color.
# -----------------------------------------------------------------------
echo ""
echo "Check 2: Inline paragraph links must have bold or italic emphasis..."

# Extract lines that:
#   - contain a markdown link  [text](url)
#   - are NOT headings (start with #)
#   - are NOT list items (start with -, *, or a digit followed by .)
#   - are NOT code fence lines (start with ```)
# Then check whether the link portion uses **bold** or _italic_ markers.
paragraph_link_violations=()
while IFS= read -r line; do
    # Skip headings, list items, and code fence lines
    if [[ "$line" =~ ^[[:space:]]*# ]] || \
       [[ "$line" =~ ^[[:space:]]*[-*] ]] || \
       [[ "$line" =~ ^[[:space:]]*[0-9]+\. ]] || \
       [[ "$line" =~ ^\`\`\` ]]; then
        continue
    fi

    # Find all markdown links on this line
    if echo "$line" | grep -qE '\[[^]]+\]\('; then
        # Check whether each link text uses bold (**...**) or italic (*...* / _..._)
        # Bold:   [**text**](url)  — must start with ** (double asterisk)
        # Italic: [*text*](url)    — must start with single * (not **)
        # Italic: [_text_](url)    — underscore style
        if ! echo "$line" | grep -qE '\[\*\*[^]]*\*\*\]\(|\[\*[^*][^]]*\*\]\(|\[_[^_][^]]*_\]\('; then
            paragraph_link_violations+=("$line")
        fi
    fi
done < "$FILE"

if [ ${#paragraph_link_violations[@]} -gt 0 ]; then
    echo "⚠️  Found inline paragraph link(s) without bold/italic emphasis:"
    for v in "${paragraph_link_violations[@]}"; do
        echo "   $v"
    done
    echo ""
    echo "   Fix: Add **bold** or _italic_ markers around the link text so"
    echo "   it is visually distinguishable from surrounding text without"
    echo "   relying on color alone."
    echo ""
    echo "   Example:  See [**student-work/TEMPLATE.md**](student-work/TEMPLATE.md)"
    EXIT_CODE=1
else
    echo "✅ All inline paragraph links use bold or italic emphasis"
fi

# -----------------------------------------------------------------------
# Summary
# -----------------------------------------------------------------------
echo ""
echo "============================================================================"
if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ README.md passes link accessibility checks (WCAG 2.1 SC 1.4.1)"
else
    echo "❌ README.md has link accessibility issues that must be fixed."
fi

exit $EXIT_CODE

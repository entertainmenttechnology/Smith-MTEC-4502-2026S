#!/bin/bash
# Test script to check that markdown links embedded inline in prose paragraphs
# are not the ONLY distinguishing feature — i.e., they should not rely solely on
# color to stand out from surrounding text (WCAG 2.1 / axe link-in-text-block rule).
#
# Strategy: Flag any markdown link [text](url) that appears mid-sentence in a
# paragraph line (not in a heading, list item, blockquote, code fence, or HTML
# block) without any additional visual indicator such as bold, italic, or backtick
# code formatting wrapped around the link.
#
# References:
#   https://dequeuniversity.com/rules/axe/4.11/link-in-text-block
#   https://www.w3.org/WAI/WCAG21/Understanding/use-of-color.html

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

echo "Checking markdown files for inline links in plain text paragraphs..."
echo "====================================================================="
echo ""
echo "WCAG 2.1 (link-in-text-block): Links within blocks of text must be"
echo "distinguishable from surrounding text without relying on color alone."
echo "Links should be placed in lists, headings, or use bold/italic/underline"
echo "formatting so they are visually distinct when color is not available."
echo ""

EXIT_CODE=0
FILES_CHECKED=0
FILES_WITH_ISSUES=0

# Write the Python checker to a temporary file for reliability
CHECKER_SCRIPT=$(mktemp /tmp/check_link_block_XXXXXX.py)
cat > "$CHECKER_SCRIPT" << 'EOF'
#!/usr/bin/env python3
"""
Check a markdown file for bare inline links in prose paragraphs.
A bare inline link is [text](url) that is NOT inside:
  - a heading line
  - a list item (-, *, +, or numbered)
  - a blockquote
  - a code fence (``` or ~~~)
  - an HTML block
  - bold/italic/code formatting immediately wrapping the link
Exit code 0 = no issues found, 1 = issues found.
"""
import sys
import re

if len(sys.argv) < 2:
    print("Usage: check_link_block.py <markdown_file>", file=sys.stderr)
    sys.exit(2)

filepath = sys.argv[1]
issues = []

try:
    with open(filepath, encoding='utf-8') as f:
        lines = f.readlines()
except Exception as e:
    print(f"Error reading {filepath}: {e}", file=sys.stderr)
    sys.exit(2)

in_code_fence = False

for lineno, line in enumerate(lines, 1):
    stripped = line.rstrip('\n')

    # Toggle code fence state
    if re.match(r'^[`~]{3}', stripped):
        in_code_fence = not in_code_fence
        continue

    if in_code_fence:
        continue

    # Skip structural / non-paragraph lines
    if re.match(r'^\s*#{1,6}\s', stripped):        # heading
        continue
    if re.match(r'^\s*[-\*\+]\s', stripped):       # unordered list item
        continue
    if re.match(r'^\s*\d+\.\s', stripped):         # ordered list item
        continue
    if re.match(r'^\s*>', stripped):               # blockquote
        continue
    if re.match(r'^\s*<', stripped):               # HTML block
        continue
    if re.match(r'^\s*[-=]{3,}\s*$', stripped):   # setext heading underline
        continue
    if stripped.strip() == '':                     # blank line
        continue

    # Find all markdown links on this prose line
    for m in re.finditer(r'\[([^\]]+)\]\([^)]+\)', stripped):
        start = m.start()
        end = m.end()
        link_text = m.group(1)
        before = stripped[:start]
        after = stripped[end:]

        # Skip standalone links: if the line has no surrounding text besides
        # the link itself (and optional whitespace/punctuation), it renders as
        # a <p> with only a link — the link-in-text-block rule does not apply.
        surrounding_text = re.sub(r'\[[^\]]+\]\([^)]*\)', '', stripped).strip()
        if not surrounding_text or not re.search(r'\w', surrounding_text):
            continue

        # Determine whether the link is visually adorned (bold, italic, code, or
        # underline), making it distinguishable from surrounding text without
        # relying on color alone.
        #
        # A link is adorned when formatting markers immediately WRAP the link:
        #   **[text](url)**  →  before ends with **,  after starts with **
        #   _[text](url)_    →  before ends with _,   after starts with _
        #   `[text](url)`    →  before ends with `,   after starts with `
        #   <u>[text](url)</u>
        #
        # Also treat as adorned when the ENTIRE link text is styled:
        #   [**bold text**](url)  →  link_text starts and ends with **
        FORMATTING_MARKERS = ('**', '__', '*', '_', '`')
        before_stripped = before.rstrip()
        after_stripped = after.lstrip()

        wrapped_before = before_stripped.endswith(FORMATTING_MARKERS + ('<u>',))
        wrapped_after = after_stripped.startswith(FORMATTING_MARKERS + ('</u>',))
        # The entire link text is styled (e.g. [**bold**](url) or [_italic_](url))
        link_text_styled = (
            any(link_text.startswith(m) and link_text.endswith(m)
                for m in ('**', '__', '*', '_', '`'))
            or (link_text.startswith('<u>') and link_text.endswith('</u>'))
        )

        is_adorned = wrapped_before or wrapped_after or link_text_styled

        if not is_adorned:
            issues.append((lineno, stripped, m.group(0)))

if issues:
    for lineno, line_text, link in issues:
        print(f"  Line {lineno}: {line_text[:120]}")
        print(f"  Link: {link}")
        print()
    sys.exit(1)

sys.exit(0)
EOF

while IFS= read -r -d '' file; do
    # Skip hidden directories (like .git)
    if [[ "$file" == *"/.git/"* ]]; then
        continue
    fi

    FILES_CHECKED=$((FILES_CHECKED + 1))
    RELPATH="${file#$REPO_ROOT/}"

    # Run the Python checker; capture output for display
    PYTHON_OUTPUT=$(python3 "$CHECKER_SCRIPT" "$file" 2>&1) || {
        echo "❌ $RELPATH"
        echo "$PYTHON_OUTPUT"
        echo "   Fix: Move bare inline links [text](url) into list items or wrap"
        echo "        with **bold**, _italic_, or \`code\` formatting so they are"
        echo "        visually distinct without relying on color alone."
        echo ""
        FILES_WITH_ISSUES=$((FILES_WITH_ISSUES + 1))
        EXIT_CODE=1
        continue
    }
    echo "✅ $RELPATH"
done < <(find "$REPO_ROOT" -name "*.md" -type f -print0 | grep -zv ".git")

# Clean up temporary Python script
rm -f "$CHECKER_SCRIPT"

echo ""
echo "====================================================================="
echo "Summary: $FILES_WITH_ISSUES/$FILES_CHECKED files have bare inline links in text paragraphs"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All markdown files pass the link-in-text-block check"
else
    echo "❌ Some markdown files have bare inline links in prose paragraphs"
    echo ""
    echo "To fix: Replace bare inline links [text](url) in plain paragraphs with:"
    echo "  - List items:  '- [text](url)'"
    echo "  - Bold links:  '**[text](url)**'"
    echo "  - Or move the link to a dedicated list/heading section"
fi

exit $EXIT_CODE

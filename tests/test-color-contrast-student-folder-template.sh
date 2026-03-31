#!/bin/bash
# Test to verify student-work/STUDENT-FOLDER-TEMPLATE.md does not contain
# structural patterns that cause low-contrast <p> rendering on GitHub.
#
# Specifically checks:
#   1. The file has a level-one heading (H1) — muting/secondary rendering
#      is more common when the page hierarchy starts below H1.
#   2. No plain paragraph immediately follows a "---" horizontal-rule
#      separator, which GitHub can render with its muted foreground color
#      (#7b7c7d) on a subtle-canvas background (#f6f8fa), failing the
#      WCAG 2.1 AA 4.5:1 contrast requirement.
#
# Related axe rule: color-contrast
# See: https://dequeuniversity.com/rules/axe/4.11/color-contrast

set -e

FILE="student-work/STUDENT-FOLDER-TEMPLATE.md"
EXIT_CODE=0

echo "Testing $FILE for color-contrast accessibility issues..."
echo "========================================================="

if [ ! -f "$FILE" ]; then
    echo "❌ File not found: $FILE"
    exit 1
fi

# ── Test 1: Must have a level-one heading ────────────────────────────────────
first_line=$(grep -v '^[[:space:]]*$' "$FILE" | head -1)
if [[ "$first_line" =~ ^#[[:space:]]+ ]]; then
    echo "✅ Has level-one heading: $first_line"
else
    echo "❌ Missing level-one heading (first non-empty line: $first_line)"
    echo "   Fix: Start the file with '# <Title>'"
    EXIT_CODE=1
fi

# ── Test 2: No plain paragraph immediately after a "---" separator ───────────
# Read the file line-by-line and flag any non-empty, non-heading line that
# directly follows a "---" line (ignoring blank lines in between).
found_hr=false
while IFS= read -r line; do
    # Detect a standalone horizontal rule
    if [[ "$line" =~ ^---[[:space:]]*$ ]]; then
        found_hr=true
        continue
    fi

    # Skip blank lines while tracking whether we are after an HR
    if [[ -z "${line// /}" ]]; then
        continue
    fi

    if $found_hr; then
        # The first non-blank line after "---" must be a heading or another HR
        if [[ "$line" =~ ^#{1,6}[[:space:]]+ ]] || [[ "$line" =~ ^---[[:space:]]*$ ]]; then
            echo "✅ Content after '---' separator is a heading or rule: $line"
        else
            echo "❌ Plain paragraph found after '---' separator: $line"
            echo "   This can render with GitHub's muted foreground color (#7b7c7d)"
            echo "   on a subtle-canvas background (#f6f8fa), failing WCAG 2.1 AA"
            echo "   4.5:1 contrast requirement."
            echo "   Fix: Convert the note/paragraph to a heading section."
            EXIT_CODE=1
        fi
        found_hr=false
    fi
done < "$FILE"

# ── Summary ──────────────────────────────────────────────────────────────────
echo ""
echo "========================================================="
if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ $FILE passes color-contrast structural checks"
else
    echo "❌ $FILE has structural issues that may cause color-contrast failures"
fi

exit $EXIT_CODE

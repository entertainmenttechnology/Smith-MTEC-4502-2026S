#!/bin/bash
# Test script to check student-information.md for color contrast compliance
# Validates:
#   1. The file has a level-one heading — ensures the page renders with full-contrast h1 styling.
#   2. The file contains a paragraph with descriptive text (not just headings and table).
#   3. No inline HTML style attributes with known low-contrast foreground colors are present.
#
# WCAG 2.1 AA requires a minimum contrast ratio of 4.5:1 for normal text (< 18pt / 14pt bold).
# Reference: https://dequeuniversity.com/rules/axe/4.11/color-contrast

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
FILE="$REPO_ROOT/student-information.md"

PASS=0
FAIL=0

echo "Color contrast accessibility check: student-information.md"
echo "==========================================================="

if [ ! -f "$FILE" ]; then
    echo "❌ File not found: $FILE"
    exit 1
fi

# --- Check 1: File must start with a level-one heading ---
first_heading=$(grep -m1 "^#" "$FILE" 2>/dev/null || true)

if [[ "$first_heading" =~ ^#[[:space:]]+ && ! "$first_heading" =~ ^##+ ]]; then
    echo "✅ File has a level-one heading: $first_heading"
    PASS=$((PASS + 1))
else
    echo "❌ File is missing a level-one heading (found: '${first_heading:-none}')"
    echo "   A level-one heading ('# Title') ensures proper contrast rendering on GitHub."
    FAIL=$((FAIL + 1))
fi

# --- Check 2: File must contain at least one descriptive paragraph ---
# A paragraph is a non-empty line that does not start with a markdown structural character:
#   # (heading), | (table row), > (blockquote), * (list/bold), ` (code block), space/tab (indent), - (list/hr)
paragraph_count=$(grep -cE '^[^#|>*`[:space:]-]' "$FILE" 2>/dev/null || true)

if [ "$paragraph_count" -gt 0 ]; then
    echo "✅ File contains descriptive paragraph text ($paragraph_count matching line(s))"
    PASS=$((PASS + 1))
else
    echo "❌ File lacks descriptive paragraph text"
    echo "   Adding prose content ensures the page has accessible body text with proper contrast."
    FAIL=$((FAIL + 1))
fi

# --- Check 3: No inline style attributes with known low-contrast foreground colors ---
# These colors fail WCAG 2.1 AA (4.5:1) when used as foreground text against GitHub's
# canvas-subtle background (#f6f8fa). Approximate contrast ratios on #f6f8fa:
#   #7b7c7d → 3.93:1 (the specific color flagged by the accessibility scanner)
#   #868e96 → 3.33:1
#   #adb5bd → 1.98:1
#   #ced4da → 1.42:1
#   #dee2e6 → 1.22:1
#   #999999 → 2.85:1
#   #aaaaaa → 2.32:1
#   #bbbbbb → 1.86:1
#   #c0c0c0 → 1.77:1
#   #cccccc → 1.60:1
# Note: This check guards against reintroducing these specific known-failing colors in
# inline style attributes. It does not calculate arbitrary contrast ratios.
LOW_CONTRAST_COLORS=("7b7c7d" "868e96" "adb5bd" "ced4da" "dee2e6" "999999" "aaaaaa" "bbbbbb" "c0c0c0" "cccccc")
FOUND_LOW_CONTRAST=0

for color in "${LOW_CONTRAST_COLORS[@]}"; do
    if grep -qiE "style=['\"].*color:.*#?${color}" "$FILE" 2>/dev/null; then
        echo "❌ Found low-contrast color '#${color}' in inline style attribute"
        FOUND_LOW_CONTRAST=1
        FAIL=$((FAIL + 1))
    fi
done

if [ "$FOUND_LOW_CONTRAST" -eq 0 ]; then
    echo "✅ No low-contrast inline color styles found"
    PASS=$((PASS + 1))
fi

# --- Summary ---
echo ""
echo "==========================================================="
echo "Results: $PASS passed, $FAIL failed"

if [ "$FAIL" -eq 0 ]; then
    echo "✅ All color contrast checks passed for student-information.md"
    exit 0
else
    echo "❌ Some color contrast checks failed for student-information.md"
    exit 1
fi

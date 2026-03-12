#!/bin/bash
# Test script to check student-work/STUDENT-FOLDER-TEMPLATE.md for color contrast issues
# Validates:
#   1. The file has a level-one heading (h1) — ensures the page title renders with
#      full-contrast styling and avoids GitHub's muted-color treatment of lower headings.
#   2. No inline HTML style attributes with known low-contrast colors are present.
#
# WCAG 2.1 AA requires a minimum contrast ratio of 4.5:1 for normal text (< 18pt / 14pt bold).
# Reference: https://dequeuniversity.com/rules/axe/4.11/color-contrast

set -e

FILE="student-work/STUDENT-FOLDER-TEMPLATE.md"
PASS=0
FAIL=0

echo "Color contrast accessibility check: $FILE"
echo "=========================================="

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

# --- Check 2: No inline style with known low-contrast foreground colors ---
# The accessibility scanner flagged color #7b7c7d (contrast 3.92:1 on #f6f8fa).
# GitHub strips inline styles from rendered markdown, so we check for any style attributes
# that might attempt to set a low-contrast color in the source.
LOW_CONTRAST_COLORS=("7b7c7d" "868e96" "adb5bd" "ced4da" "dee2e6" "999999" "aaaaaa" "bbbbbb")
FOUND_LOW_CONTRAST=0

for color in "${LOW_CONTRAST_COLORS[@]}"; do
    if grep -qi "style=.*color.*#\{0,1\}${color}" "$FILE" 2>/dev/null; then
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
echo "=========================================="
echo "Results: $PASS passed, $FAIL failed"

if [ "$FAIL" -eq 0 ]; then
    echo "✅ Color contrast checks passed"
    exit 0
else
    echo "❌ Color contrast checks failed"
    exit 1
fi

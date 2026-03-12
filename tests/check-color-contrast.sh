#!/bin/bash
# Test script to check markdown files for potential color contrast accessibility issues.
# Checks for:
#   1. Inline HTML with explicit low-contrast color styles (e.g., color:#7b7c7d)
#   2. Plain blockquotes without GFM alert syntax that may render with muted text colors
#      in GitHub's blob view, causing WCAG 2.1 color-contrast violations.
#
# Background: GitHub renders plain blockquotes with muted/secondary foreground color
# (~#7b7c7d) on the page background (#f6f8fa), which produces a contrast ratio of ~3.92,
# below the WCAG 2 AA minimum of 4.5:1 for normal-sized text.
# Using GitHub-Flavored Markdown (GFM) alert callouts (> [!NOTE], > [!IMPORTANT], etc.)
# instead ensures GitHub applies accessible, controlled color schemes.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

echo "Checking markdown files for potential color contrast issues..."
echo "============================================================="
echo ""

EXIT_CODE=0
FILES_CHECKED=0
FILES_PASSED=0

# Low-contrast color pairs known to fail WCAG 2.1 AA (contrast < 4.5:1 on #f6f8fa)
LOW_CONTRAST_COLORS=("7b7c7d" "7b7c7e" "808080" "888888" "999999" "aaaaaa")

while IFS= read -r -d '' file; do
    if [[ "$file" == *"/.git/"* ]]; then
        continue
    fi

    FILES_CHECKED=$((FILES_CHECKED + 1))
    FILE_ISSUES=0

    # --- Check 1: Inline HTML with explicit low-contrast color styles ---
    for color in "${LOW_CONTRAST_COLORS[@]}"; do
        if grep -qiE "(color\s*:\s*#?${color}|color\s*=\s*['\"]?#?${color})" "$file" 2>/dev/null; then
            if [ $FILE_ISSUES -eq 0 ]; then
                echo "❌ $file"
            fi
            echo "   Issue: Inline color style '#${color}' may produce insufficient contrast (< 4.5:1)"
            FILE_ISSUES=$((FILE_ISSUES + 1))
            EXIT_CODE=1
        fi
    done

    # --- Check 2: Plain blockquotes (blockquote sequences where the first line is not a GFM alert) ---
    # These may render with muted foreground color on GitHub's blob view.
    # A GFM alert starts with "> [!TYPE]" as its first line; continuation lines also start with "> ".
    # We detect plain blockquotes by finding "> " lines that start a NEW blockquote context
    # (i.e., preceded by a non-blockquote line) where the first line is NOT "> [!...".
    plain_blockquotes=$(awk '
        /^[^>]/ || /^$/ { in_block=0; next }
        /^> \[!/ { in_block=1; next }
        /^>/ {
            if (!in_block) { print NR": "$0; in_block=1 }
        }
    ' "$file" 2>/dev/null)
    if [ -n "$plain_blockquotes" ]; then
        if [ $FILE_ISSUES -eq 0 ]; then
            echo "⚠️  $file"
        fi
        echo "   Warning: Contains plain blockquote(s) that may render with muted text color on GitHub."
        echo "   Consider using GFM alert syntax: > [!NOTE], > [!IMPORTANT], > [!WARNING], etc."
        FILE_ISSUES=$((FILE_ISSUES + 1))
        # Treat as warning only, do not fail build
    fi

    if [ $FILE_ISSUES -eq 0 ]; then
        echo "✅ $file"
        FILES_PASSED=$((FILES_PASSED + 1))
    fi

done < <(find . -name "*.md" -type f -print0 | grep -zv ".git")

echo ""
echo "============================================================="
echo "Summary: $FILES_PASSED/$FILES_CHECKED files checked"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ No critical color contrast issues found in markdown files"
else
    echo "❌ Color contrast issues found — fix inline color styles with insufficient contrast"
    echo ""
    echo "WCAG 2.1 AA requires a contrast ratio of at least 4.5:1 for normal text."
    echo "See: https://dequeuniversity.com/rules/axe/4.11/color-contrast"
fi

exit $EXIT_CODE

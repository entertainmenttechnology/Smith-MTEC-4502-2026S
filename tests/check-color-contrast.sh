#!/bin/bash
# Test script to check markdown files for potential color contrast accessibility issues
# Validates WCAG 2.1 AA compliance by checking for:
# 1. Inline HTML with low-contrast color values (hard failure)
# 2. Bold-inside-heading patterns that can cause muted text rendering on GitHub
#    - Hard failure for files that have been specifically fixed for this issue
#    - Warning only for other files (pre-existing patterns)
#
# Reference: https://dequeuniversity.com/rules/axe/4.11/color-contrast

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
WARNINGS=0

# Known low-contrast foreground colors against GitHub's canvas-subtle (#f6f8fa) background
# These colors have contrast ratios below 4.5:1 (required for normal text at 14px)
LOW_CONTRAST_COLORS=(
  "#7b7c7d"
  "#7b7c7e"
  "#868e96"
  "#8c959f"
  "#9198a1"
  "#6e7781"
  "#636c76"
)

# Files that have been specifically fixed for color contrast issues.
# Bold-inside-heading patterns in these files are hard failures (regression prevention).
FIXED_FILES=(
  "assignments/01c MTEC 4502 Assignment week 3  - Integrating Visualization.md"
)

is_fixed_file() {
    local file="$1"
    local rel_path="${file#./}"
    for fixed in "${FIXED_FILES[@]}"; do
        if [ "$rel_path" = "$fixed" ]; then
            return 0
        fi
    done
    return 1
}

while IFS= read -r -d '' file; do
    FILES_CHECKED=$((FILES_CHECKED + 1))
    FILE_PASSED=true

    # Check 1: Look for inline HTML style attributes with low-contrast colors (hard failure)
    for color in "${LOW_CONTRAST_COLORS[@]}"; do
        if grep -qi "style=['\"].*color:\s*${color}" "$file" 2>/dev/null; then
            echo "❌ $file"
            echo "   Low-contrast inline color found: ${color}"
            echo "   This color has insufficient contrast against #f6f8fa background (< 4.5:1)"
            FILE_PASSED=false
            EXIT_CODE=1
        fi
    done

    # Check 2: Look for <font color="..."> tags with low-contrast colors (hard failure)
    for color in "${LOW_CONTRAST_COLORS[@]}"; do
        if grep -qi "<font[^>]*color=['\"]${color}['\"]" "$file" 2>/dev/null; then
            echo "❌ $file"
            echo "   Low-contrast <font> color found: ${color}"
            echo "   This color has insufficient contrast against #f6f8fa background (< 4.5:1)"
            FILE_PASSED=false
            EXIT_CODE=1
        fi
    done

    # Check 3: Bold-inside-heading patterns (## **text** or ### **text**)
    # These can cause muted text rendering on GitHub in some themes.
    # Hard failure for files that have been explicitly fixed; warning for others.
    if grep -qE "^#{1,6} \*\*" "$file" 2>/dev/null; then
        if is_fixed_file "$file"; then
            echo "❌ $file"
            echo "   Bold-inside-heading pattern found (regression): '## **text**' should be '## text'"
            echo "   This pattern was previously fixed to resolve color contrast issues (WCAG 2.1 AA)"
            FILE_PASSED=false
            EXIT_CODE=1
        else
            echo "⚠️  $file (warning)"
            echo "   Contains bold-inside-heading pattern (e.g., ## **text**)"
            echo "   Consider changing to standard headings to improve color contrast compatibility"
            WARNINGS=$((WARNINGS + 1))
        fi
    fi

    if [ "$FILE_PASSED" = true ]; then
        echo "✅ $file"
        FILES_PASSED=$((FILES_PASSED + 1))
    fi

done < <(find . -name "*.md" -type f ! -path "*/.git/*" -print0)

echo ""
echo "============================================================="
echo "Summary: $FILES_PASSED/$FILES_CHECKED files passed | $WARNINGS warnings"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ No color contrast violations found in markdown files"
    if [ $WARNINGS -gt 0 ]; then
        echo "ℹ️  $WARNINGS file(s) have warnings about bold-inside-heading patterns"
        echo "   Consider fixing: Replace '## **text**' with '## text' for better accessibility"
    fi
else
    echo "❌ Color contrast violations detected"
    echo ""
    echo "To fix:"
    echo "  - Replace bold-inside-heading patterns: '## **text**' → '## text'"
    echo "  - Replace low-contrast inline colors with WCAG AA compliant values"
    echo "  - Minimum contrast ratio: 4.5:1 for normal text (14px), 3:1 for large/bold text"
    echo ""
    echo "Reference: https://dequeuniversity.com/rules/axe/4.11/color-contrast"
fi

exit $EXIT_CODE

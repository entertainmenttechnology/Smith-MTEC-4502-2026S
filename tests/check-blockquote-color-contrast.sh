#!/bin/bash
# Test script to check that resources/11_resume_development_guide.md does not contain
# bare markdown blockquotes ("> text") that would render with GitHub's low-contrast
# muted text color (#7b7c7d on #f6f8fa = 3.92:1, below WCAG 2 AA minimum of 4.5:1).
# The blockquote at the end of that file must use an HTML element with an explicit
# high-contrast color so that it passes color-contrast axe/WCAG checks.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

FILE="$REPO_ROOT/resources/11_resume_development_guide.md"

echo "Checking $FILE for bare markdown blockquotes (color contrast regression)..."
echo "==========================================================================="

if [ ! -f "$FILE" ]; then
    echo "❌ File not found: $FILE"
    exit 1
fi

# Check for bare markdown blockquote lines (lines starting with "> ")
# These would render with GitHub's low-contrast muted color.
if grep -Pn "^> " "$FILE"; then
    echo ""
    echo "❌ $FILE contains bare markdown blockquote(s) shown above."
    echo "   These render with a low-contrast color on GitHub (#7b7c7d on #f6f8fa = 3.92:1)."
    echo "   Use an HTML <blockquote style=\"color: #24292f;\"> instead to meet WCAG 2 AA (4.5:1)."
    exit 1
fi

echo "✅ $FILE has no bare markdown blockquotes — color contrast requirement is met."
exit 0

#!/bin/bash
# Test script to check that README.md has a main landmark for accessibility compliance
# This ensures WCAG 2.1 compliance by validating that the document has a main landmark
# (landmark-one-main axe rule)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

FILE="$REPO_ROOT/README.md"

echo "Testing README.md for main landmark (<main> element)..."
echo "========================================================"

if [ ! -f "$FILE" ]; then
    echo "❌ File not found: README.md"
    exit 1
fi

# Check that the file contains an opening <main> tag (not inside a code block comment)
if grep -qE "<main[[:space:]>]" "$FILE"; then
    echo "✅ README.md has a <main> landmark element"
    exit 0
else
    echo "❌ README.md is missing a <main> landmark element"
    echo ""
    echo "To fix: Wrap the main content of README.md in a <main> element."
    echo "Example:"
    echo "  <main>"
    echo ""
    echo "  # Page Title"
    echo "  ..."
    echo ""
    echo "  </main>"
    echo ""
    echo "This is required for WCAG 2.1 accessibility compliance (landmark-one-main rule)."
    exit 1
fi

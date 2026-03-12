#!/bin/bash
# Test script to check README.md has a <main> landmark for accessibility compliance
# This ensures the landmark-one-main axe rule is satisfied (WCAG 2.1)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
FILE="$REPO_ROOT/README.md"

echo "Checking README.md for <main> landmark..."
echo "==========================================="
echo ""

if [ ! -f "$FILE" ]; then
    echo "❌ File not found: README.md"
    exit 1
fi

if grep -q "<main>" "$FILE" && grep -q "</main>" "$FILE"; then
    echo "✅ README.md has a <main> landmark (opening and closing tags)"
    exit 0
else
    if ! grep -q "<main>" "$FILE"; then
        echo "❌ README.md is missing an opening <main> tag"
    fi
    if ! grep -q "</main>" "$FILE"; then
        echo "❌ README.md is missing a closing </main> tag"
    fi
    echo ""
    echo "To fix: Wrap the page content with <main> and </main> HTML tags."
    echo "Example:"
    echo "  <main>"
    echo ""
    echo "  # Page Title"
    echo "  ..."
    echo ""
    echo "  </main>"
    exit 1
fi

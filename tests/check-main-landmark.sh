#!/bin/bash
# Test script to check that resources/02_Resources.md has a main landmark
# This ensures WCAG 2.1 compliance by validating that the page has a <main> element
# which satisfies the axe landmark-one-main accessibility rule

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

echo "Checking resources/02_Resources.md for main landmark..."
echo "========================================================="
echo ""

TARGET_FILE="resources/02_Resources.md"

if [ ! -f "$TARGET_FILE" ]; then
    echo "❌ File not found: $TARGET_FILE"
    exit 1
fi

if grep -q "<main>" "$TARGET_FILE" && grep -q "</main>" "$TARGET_FILE"; then
    echo "✅ $TARGET_FILE has a <main> landmark"
    exit 0
else
    echo "❌ $TARGET_FILE is missing a complete <main> landmark"
    echo "   Expected: A <main> HTML element wrapping the page content"
    echo "   To fix: Wrap the page content with <main>...</main> tags"
    exit 1
fi

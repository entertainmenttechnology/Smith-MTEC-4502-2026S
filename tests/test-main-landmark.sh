#!/bin/bash
# Test script to check that the assignment file has a main landmark for accessibility
# This ensures WCAG 2.1 compliance with the landmark-one-main rule
# See: https://dequeuniversity.com/rules/axe/4.11/landmark-one-main

set -e

FILE="assignments/05-Assignment_Evaluating_Portfolio_Platforms.md"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
FULL_PATH="$REPO_ROOT/$FILE"

echo "Testing $FILE for main landmark..."

if [ ! -f "$FULL_PATH" ]; then
    echo "❌ File not found: $FILE"
    exit 1
fi

HAS_MAIN_OPEN=$(grep -c '^<main>' "$FULL_PATH" || true)
HAS_MAIN_CLOSE=$(grep -c '^</main>' "$FULL_PATH" || true)

if [ "$HAS_MAIN_OPEN" -ge 1 ] && [ "$HAS_MAIN_CLOSE" -ge 1 ]; then
    echo "✅ $FILE has a main landmark (<main>...</main>)"
    exit 0
else
    echo "❌ $FILE is missing a main landmark"
    echo "   Expected: <main> opening tag and </main> closing tag"
    echo "   Found <main> tags: $HAS_MAIN_OPEN"
    echo "   Found </main> tags: $HAS_MAIN_CLOSE"
    echo ""
    echo "To fix: Wrap the document content with <main> and </main> HTML tags."
    echo "This is required for WCAG 2.1 accessibility compliance (landmark-one-main rule)."
    exit 1
fi

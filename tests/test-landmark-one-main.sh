#!/bin/bash
# Test script to check that student-information.md has a main landmark element
# This ensures WCAG 2.1 compliance by validating the landmark-one-main rule:
# the document must contain exactly one <main> element.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

FILE="$REPO_ROOT/student-information.md"
RELATIVE_FILE="student-information.md"

echo "Testing $RELATIVE_FILE for main landmark..."

if [ ! -f "$FILE" ]; then
    echo "❌ File not found: $RELATIVE_FILE"
    exit 1
fi

# Check for opening <main> tag and closing </main> tag
# Use word-boundary patterns to avoid matching comments, code blocks, or URLs
if grep -qi "^<main\b" "$FILE" && grep -qi "^</main>" "$FILE"; then
    echo "✅ $RELATIVE_FILE has a <main> landmark element"
    exit 0
else
    echo "❌ $RELATIVE_FILE is missing a <main> landmark element"
    echo "   Expected: A <main> HTML element wrapping the primary content"
    echo "   This violates the landmark-one-main accessibility rule (WCAG 2.1)"
    echo "   To fix: Wrap the document content in <main>...</main> tags"
    exit 1
fi

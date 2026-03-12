#!/bin/bash
# Test that resources/09_portfolio_planning.md contains a <main> landmark
# This ensures WCAG 2.1 compliance by validating the document has a main landmark
# (landmark-one-main rule)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

FILE="$REPO_ROOT/resources/09_portfolio_planning.md"

echo "Testing $FILE for <main> landmark..."

if [ ! -f "$FILE" ]; then
    echo "❌ File not found: $FILE"
    exit 1
fi

if grep -q '<main>' "$FILE" && grep -q '</main>' "$FILE"; then
    echo "✅ $FILE has a <main> landmark"
    exit 0
else
    echo "❌ $FILE is missing a <main> landmark"
    echo "   Expected: Opening <main> and closing </main> HTML elements wrapping the page content"
    exit 1
fi

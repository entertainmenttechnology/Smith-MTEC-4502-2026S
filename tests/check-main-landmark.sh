#!/bin/bash
# Test script to check that the resume development guide has a main landmark
# This ensures WCAG 2.1 compliance with the landmark-one-main rule by validating
# that the document contains a <main> HTML element for screen reader navigation.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

FILE="$REPO_ROOT/resources/11_resume_development_guide.md"

echo "Checking $FILE for <main> landmark..."
echo "=================================================="
echo ""

if [ ! -f "$FILE" ]; then
    echo "❌ File not found: $FILE"
    exit 1
fi

if grep -qE '<main[[:space:]>]' "$FILE"; then
    echo "✅ $FILE has a <main> landmark"
    echo "   This satisfies the WCAG 2.1 landmark-one-main accessibility requirement."
    exit 0
else
    echo "❌ $FILE is missing a <main> landmark"
    echo "   The document must contain a <main> HTML element to serve as the"
    echo "   primary landmark for screen reader navigation."
    echo ""
    echo "   To fix: Add <main> near the top of the file and </main> at the end."
    echo "   Example:"
    echo "     <main>"
    echo "     "
    echo "     # Document Title"
    echo "     ...content..."
    echo "     </main>"
    exit 1
fi

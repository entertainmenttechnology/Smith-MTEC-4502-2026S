#!/bin/bash
# Test script to check student-work/STUDENT-FOLDER-TEMPLATE.md has a <main> landmark
# Ensures WCAG 2.1 / axe landmark-one-main compliance for the rendered document

set -e

FILE="student-work/STUDENT-FOLDER-TEMPLATE.md"

echo "Testing $FILE for <main> landmark..."

if [ ! -f "$FILE" ]; then
    echo "❌ File not found: $FILE"
    exit 1
fi

# Check that the file contains a <main> opening tag (not inside a code block or comment)
if grep -qE '^<main>|^<main[[:space:]]' "$FILE"; then
    echo "✅ $FILE has a <main> landmark"
    exit 0
else
    echo "❌ $FILE is missing a <main> landmark"
    echo "   Expected: A <main> HTML element wrapping the primary content"
    echo "   Fix: Add <main> ... </main> around the document's main content"
    exit 1
fi

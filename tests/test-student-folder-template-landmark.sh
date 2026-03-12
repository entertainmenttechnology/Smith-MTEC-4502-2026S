#!/bin/bash
# Specific test for student-work/STUDENT-FOLDER-TEMPLATE.md accessibility
# Ensures the file has a <main> landmark element as required by WCAG 2.1 (landmark-one-main rule)

set -e

FILE="student-work/STUDENT-FOLDER-TEMPLATE.md"

echo "Testing $FILE for main landmark..."

if [ ! -f "$FILE" ]; then
    echo "❌ File not found: $FILE"
    exit 1
fi

# Check for both opening and closing <main> elements in the file
if grep -q "<main>" "$FILE" && grep -q "</main>" "$FILE"; then
    echo "✅ $FILE has a <main> landmark element"
    exit 0
else
    echo "❌ $FILE is missing a complete <main> landmark element"
    echo "   Expected: Both <main> and </main> HTML tags wrapping the page content"
    echo "   Fix: Add <main> and </main> tags around the main content"
    exit 1
fi

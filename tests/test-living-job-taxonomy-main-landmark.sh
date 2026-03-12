#!/bin/bash
# Specific test for resources/Living Job Taxonomy.md accessibility
# Ensures the file has a main landmark as required by WCAG 2.1
# Addresses: landmark-one-main axe rule (https://dequeuniversity.com/rules/axe/4.11/landmark-one-main)

set -e

FILE="resources/Living Job Taxonomy.md"

echo "Testing '$FILE' for main landmark (<main> element)..."

if [ ! -f "$FILE" ]; then
    echo "❌ File not found: $FILE"
    exit 1
fi

# Check for <main> opening tag
if grep -q "<main" "$FILE"; then
    echo "✅ '$FILE' has a main landmark (<main> element)"
    exit 0
else
    echo "❌ '$FILE' is missing a main landmark (<main> element)"
    echo "   Expected: A <main> element wrapping the primary content"
    echo "   Fix: Add <main> after the page heading and </main> at the end of the file"
    exit 1
fi

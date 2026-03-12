#!/bin/bash
# Test script to check that markdown files have HTML landmark regions for accessibility compliance
# This ensures WCAG 2.1 compliance by validating that pages use landmark HTML elements
# (such as <main>, <nav>, <header>, <footer>, <aside>, or <article>)
# which satisfies the axe "region" rule: All page content should be contained by landmarks.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

echo "Checking markdown files for HTML landmark regions..."
echo "====================================================="
echo ""

EXIT_CODE=0
FILES_CHECKED=0
FILES_PASSED=0

# Files that are required to have landmark regions
# Add files here as they are fixed for the "region" axe rule
REQUIRED_FILES=(
    "resources/02_emerging_media_careers.md"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo "❌ File not found: $file"
        EXIT_CODE=1
        continue
    fi

    FILES_CHECKED=$((FILES_CHECKED + 1))

    # Check for HTML landmark elements: <main>, <nav>, <header>, <footer>, <aside>, <article>
    if grep -qiE '<(main|nav|header|footer|aside|article)[^>]*>' "$file"; then
        echo "✅ $file has HTML landmark region(s)"
        FILES_PASSED=$((FILES_PASSED + 1))
    else
        echo "❌ $file"
        echo "   Missing HTML landmark region(s)"
        echo "   Expected: At least one of <main>, <nav>, <header>, <footer>, <aside>, or <article>"
        EXIT_CODE=1
    fi
done

echo ""
echo "====================================================="
echo "Summary: $FILES_PASSED/$FILES_CHECKED required files have HTML landmark regions"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All required markdown files have HTML landmark regions"
else
    echo "❌ Some markdown files are missing HTML landmark regions"
    echo ""
    echo "To fix: Wrap page content in an HTML landmark element such as <main>...</main>"
    echo "This satisfies the WCAG 2.1 / axe 'region' rule:"
    echo "  All page content should be contained by landmarks"
fi

exit $EXIT_CODE

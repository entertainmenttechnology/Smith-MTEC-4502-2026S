#!/bin/bash
# Test script to check markdown files have a main landmark for accessibility compliance
# This ensures WCAG 2.1 compliance by validating that pages have a <main> landmark
# which satisfies the axe landmark-one-main rule.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

echo "Checking markdown files for <main> landmark..."
echo "=================================================="
echo ""

EXIT_CODE=0
FILES_CHECKED=0
FILES_PASSED=0

# Target file for this specific accessibility fix
TARGET_FILE="assignments/01a_Reflective_essay_draft_speculation_phase.md"

FILES_CHECKED=$((FILES_CHECKED + 1))

if [ ! -f "$TARGET_FILE" ]; then
    echo "❌ File not found: $TARGET_FILE"
    EXIT_CODE=1
else
    # Check if file contains a <main> HTML landmark element (exact tag, not partial match)
    if grep -qE "<main[[:space:]>]" "$TARGET_FILE"; then
        echo "✅ $TARGET_FILE"
        FILES_PASSED=$((FILES_PASSED + 1))
    else
        echo "❌ $TARGET_FILE"
        echo "   Expected: File contains a <main> HTML landmark element"
        echo "   Fix: Wrap the document content in <main>...</main> tags"
        EXIT_CODE=1
    fi
fi

echo ""
echo "=================================================="
echo "Summary: $FILES_PASSED/$FILES_CHECKED files have a <main> landmark"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ Main landmark check passed"
else
    echo "❌ Main landmark check failed"
    echo ""
    echo "To fix: Add a <main> element wrapping the document content"
    echo "Example:"
    echo "  <main>"
    echo "  # Page Title"
    echo "  ...content..."
    echo "  </main>"
fi

exit $EXIT_CODE

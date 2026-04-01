#!/bin/bash
# Script to check that assignments/01a_Reflective_essay_draft_speculation_phase.md
# has a <main> landmark element, satisfying the landmark-one-main accessibility rule (WCAG 2.1)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

FILE="$REPO_ROOT/assignments/01a_Reflective_essay_draft_speculation_phase.md"
REL_PATH="assignments/01a_Reflective_essay_draft_speculation_phase.md"

echo "Checking $REL_PATH for <main> landmark element..."

if [ ! -f "$FILE" ]; then
    echo "❌ File not found: $REL_PATH"
    exit 1
fi

if grep -q "<main>" "$FILE" && grep -q "</main>" "$FILE"; then
    echo "✅ Has <main> landmark: $REL_PATH"
    exit 0
else
    echo "❌ Missing <main> landmark: $REL_PATH"
    echo ""
    echo "To fix: Wrap the page content with <main>...</main> in the file."
    echo "This is required to satisfy the landmark-one-main accessibility rule (WCAG 2.1)."
    exit 1
fi

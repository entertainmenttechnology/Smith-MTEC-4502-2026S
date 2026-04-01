#!/bin/bash
# Test script to check assignments/01a_Reflective_essay_draft_speculation_phase.md
# has a <main> landmark element for accessibility compliance.
# This ensures WCAG 2.1 compliance by satisfying the landmark-one-main rule.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

FILE="$REPO_ROOT/assignments/01a_Reflective_essay_draft_speculation_phase.md"
REL_PATH="assignments/01a_Reflective_essay_draft_speculation_phase.md"

echo "Testing $REL_PATH for <main> landmark element..."

if [ ! -f "$FILE" ]; then
    echo "❌ File not found: $REL_PATH"
    exit 1
fi

if grep -q "<main>" "$FILE" && grep -q "</main>" "$FILE"; then
    echo "✅ $REL_PATH has a <main> landmark element"
    exit 0
else
    echo "❌ $REL_PATH is missing a <main> landmark element"
    echo "   Expected: A <main>...</main> wrapper around the page content"
    echo "   This is required for WCAG 2.1 landmark-one-main compliance."
    exit 1
fi

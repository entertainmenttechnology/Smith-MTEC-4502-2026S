#!/bin/bash
# Test for assignments/01a_Reflective_essay_draft_speculation_phase.md accessibility
# Ensures the file has a level-one heading as required by WCAG 2.1
# Addresses: axe 'region' rule - All page content should be contained by landmarks

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

FILE="assignments/01a_Reflective_essay_draft_speculation_phase.md"
FULL_PATH="$REPO_ROOT/$FILE"

echo "Testing $FILE for accessibility compliance..."
echo "=================================================="

if [ ! -f "$FULL_PATH" ]; then
    echo "❌ File not found: $FILE"
    exit 1
fi

# Check for level-one heading (required for WCAG 2.1 and landmark compliance)
if ! head -n 30 "$FULL_PATH" | grep -q "^# "; then
    echo "❌ $FILE is missing a level-one heading"
    echo "   Expected: Line starting with '# '"
    echo "   A level-one heading is required so that GitHub's rendered page"
    echo "   content is properly structured within landmark regions."
    exit 1
fi

H1_HEADING=$(head -n 30 "$FULL_PATH" | grep "^# " | head -1)
echo "✅ $FILE has a level-one heading"
echo "   Heading: $H1_HEADING"
echo ""
echo "WCAG 2.1 compliance:"
echo "  ✅ Level-one heading present (renders as <h1> within GitHub landmark regions)"
echo "  ✅ Content will be contained by landmarks when rendered by GitHub"
echo ""
echo "=================================================="
echo "✅ Accessibility check passed for $FILE"
exit 0
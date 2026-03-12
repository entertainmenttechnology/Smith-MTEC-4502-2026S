#!/bin/bash
# Specific test for assignment 01c2 landmark/region accessibility compliance.
# Verifies that the file satisfies the axe 'region' rule by ensuring
# the first rendered content line is a level-one heading.
# See: https://dequeuniversity.com/rules/axe/4.11/region

set -e

FILE="assignments/01c2-mtec_4502_assignment_1c_part2_future_modeling_and_adaptive_planning.md"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

echo "Testing $FILE for landmark/region accessibility (axe 'region' rule)..."

if [ ! -f "$FILE" ]; then
    echo "❌ File not found: $FILE"
    exit 1
fi

# Find the first non-empty, non-comment line
# HTML comments (<!-- ... -->) are not rendered content and should be skipped
# Use sed to strip HTML comments (including multi-line) before finding first content line
first_content_line=$(sed '/<!--/,/-->/d' "$FILE" | grep -v '^[[:space:]]*$' | head -1)

if [[ "$first_content_line" =~ ^#[[:space:]]+ ]]; then
    echo "✅ $FILE passes the 'region' landmark accessibility check"
    echo "   First rendered content: $first_content_line"
    exit 0
else
    echo "❌ $FILE fails the 'region' landmark accessibility check"
    echo "   First rendered content: $first_content_line"
    echo "   Expected: A level-one heading (starting with '# ') as the first rendered content"
    echo ""
    echo "   Fix: Ensure the H1 heading appears before any other rendered content."
    echo "   HTML comments (<!-- -->) before the H1 are allowed and will not be rendered."
    exit 1
fi

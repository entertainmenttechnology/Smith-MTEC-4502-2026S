#!/bin/bash
# Specific test for assignments/01c MTEC 4502 Assignment week 3 - Integrating Visualization.md
# Ensures the file has a level-one heading as required by WCAG 2.1
# This test prevents regression of the accessibility issue fixed in PR #[number]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
FILE="$REPO_ROOT/assignments/01c MTEC 4502 Assignment week 3  - Integrating Visualization.md"

echo "Testing assignments/01c MTEC 4502 Assignment week 3 - Integrating Visualization.md for level-one heading..."

if [ ! -f "$FILE" ]; then
    echo "❌ File not found: $FILE"
    exit 1
fi

# Get first non-empty line
first_line=$(head -20 "$FILE" | grep -v '^[[:space:]]*$' | head -1)

if [[ "$first_line" =~ ^#[[:space:]]+ ]]; then
    echo "✅ File has a level-one heading"
    echo "   Heading: $first_line"
    
    # Additional check: ensure no escaped characters in heading
    if [[ "$first_line" =~ \\ ]]; then
        echo "⚠️  Warning: Heading contains escaped characters (\\)"
        echo "   Consider removing unnecessary escape characters for better compatibility"
    fi
    
    exit 0
else
    echo "❌ File is missing a level-one heading"
    echo "   First non-empty line: $first_line"
    echo "   Expected: Line starting with '# '"
    echo ""
    echo "WCAG 2.1 Requirement: Pages must contain a level-one heading"
    echo "Reference: https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one"
    exit 1
fi

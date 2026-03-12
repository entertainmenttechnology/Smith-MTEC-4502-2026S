#!/bin/bash
# Test script to check assignments/01c2-mtec_4502_assignment_1c_part2_future_modeling_and_adaptive_planning.md
# has a lang attribute declared in YAML front matter for accessibility compliance.
# This ensures the html-has-lang axe rule (WCAG 2.1) is not violated when the document
# is rendered as HTML.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

FILE="$REPO_ROOT/assignments/01c2-mtec_4502_assignment_1c_part2_future_modeling_and_adaptive_planning.md"

echo "Testing $FILE for lang attribute in front matter..."

if [ ! -f "$FILE" ]; then
    echo "❌ File not found: $FILE"
    exit 1
fi

# Extract YAML front matter block (content between the first pair of --- delimiters)
# and check for a lang attribute (allowing optional leading whitespace)
front_matter=$(awk '/^---$/{if(found++){ exit } next} found' "$FILE")

if echo "$front_matter" | grep -qE "^\s*lang:"; then
    echo "✅ $FILE has a lang attribute in front matter"
    lang_value=$(echo "$front_matter" | grep -E "^\s*lang:" | head -1)
    echo "   $lang_value"
    exit 0
else
    echo "❌ $FILE is missing a lang attribute in YAML front matter"
    echo "   Expected: lang: en (or another language code) in YAML front matter at the top of the file"
    echo "   This is required to satisfy the html-has-lang accessibility rule (WCAG 2.1)"
    echo ""
    echo "   To fix: Add the following at the very beginning of the file:"
    echo "   ---"
    echo "   lang: en"
    echo "   ---"
    exit 1
fi

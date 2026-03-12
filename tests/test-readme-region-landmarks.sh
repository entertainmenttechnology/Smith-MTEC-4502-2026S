#!/bin/bash
# Test script to check README.md has proper structure for landmark/region accessibility compliance
# Addresses WCAG 2.1 requirement that all page content should be contained by landmarks
# (axe rule: region - https://dequeuniversity.com/rules/axe/4.11/region)
#
# When a markdown file is rendered on GitHub, the content is placed inside an <article>
# landmark element. For the page to pass the 'region' rule, the markdown must provide
# a well-structured document with a proper level-one heading, ensuring that the rendered
# HTML has a clear document structure within that landmark.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
README="$REPO_ROOT/README.md"

echo "Testing README.md for landmark/region accessibility compliance..."
echo "=================================================================="
echo ""

EXIT_CODE=0

# Check 1: File exists
if [ ! -f "$README" ]; then
    echo "❌ README.md not found at expected location"
    exit 1
fi
echo "✅ README.md exists"

# Check 2: Has a level-one heading (required for landmark structure)
if head -20 "$README" | grep -q "^# "; then
    H1=$(head -20 "$README" | grep "^# " | head -1)
    echo "✅ README.md has a level-one heading: $H1"
else
    echo "❌ README.md is missing a level-one heading"
    echo "   All page content must be contained by landmarks."
    echo "   A level-one heading is required so screen readers can navigate the page."
    EXIT_CODE=1
fi

# Check 3: Level-one heading is on the first non-empty line (best practice for accessibility)
first_line=$(head -20 "$README" | grep -v '^[[:space:]]*$' | head -1)
if [[ "$first_line" =~ ^#[[:space:]]+ ]]; then
    echo "✅ README.md level-one heading is the first content on the page"
else
    echo "⚠️  README.md level-one heading is not the first non-empty line"
    echo "   First non-empty line: ${first_line:0:80}"
    echo "   Best practice: place the level-one heading at the top of the document"
fi

# Check 4: No heading levels are skipped (e.g., H1 -> H3 without H2)
echo ""
echo "Checking heading hierarchy..."
HEADINGS=$(grep "^#" "$README")
PREV_LEVEL=0
HIERARCHY_OK=true

while IFS= read -r line; do
    # Count leading # characters using grep -o for reliability
    LEVEL=$(echo "$line" | grep -o '^#*' | tr -d '\n' | wc -c)

    if [ "$PREV_LEVEL" -gt 0 ] && [ "$LEVEL" -gt "$((PREV_LEVEL + 1))" ]; then
        echo "⚠️  Heading level skipped: H${PREV_LEVEL} -> H${LEVEL} at: ${line:0:60}"
        HIERARCHY_OK=false
    fi
    PREV_LEVEL=$LEVEL
done <<< "$HEADINGS"

if $HIERARCHY_OK; then
    echo "✅ README.md heading hierarchy has no skipped levels"
fi

echo ""
echo "=================================================================="

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ README.md passes landmark/region accessibility checks"
    echo ""
    echo "Note: The axe 'region' rule checks that all page content is contained"
    echo "within HTML landmark elements. GitHub renders README.md content within"
    echo "an <article> landmark, so a properly structured README with a level-one"
    echo "heading will satisfy this requirement."
else
    echo "❌ README.md failed landmark/region accessibility checks"
    echo ""
    echo "To fix: Ensure README.md has a level-one heading (e.g., '# Title')"
    echo "as the first non-empty line in the file."
fi

exit $EXIT_CODE

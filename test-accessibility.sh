#!/bin/bash
# Accessibility Test: Verify all markdown files have level-one headings
# This helps ensure WCAG 2.1 compliance for page structure

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "🔍 Testing markdown files for level-one headings (h1)..."
echo ""

# Counter for results
PASS=0
FAIL=0
TOTAL=0

# Find all markdown files, excluding common directories that should be ignored
while IFS= read -r -d '' file; do
    TOTAL=$((TOTAL + 1))
    
    # Get relative path for cleaner output
    rel_path="${file#./}"
    
    # Check if file has a level-one heading (line starting with single #)
    # Must be at the start of a line, followed by whitespace
    # Using POSIX character class for more robust matching
    if grep -q '^#[[:space:]]' "$file"; then
        echo -e "${GREEN}✓${NC} $rel_path"
        PASS=$((PASS + 1))
    else
        echo -e "${RED}✗${NC} $rel_path - Missing level-one heading"
        FAIL=$((FAIL + 1))
    fi
done < <(find . -name "*.md" -type f -not -path "./.git/*" -not -path "./node_modules/*" -not -path "./.venv/*" -not -path "./vendor/*" -not -path "./dist/*" -not -path "./build/*" -print0 | sort -z)

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Results: $PASS passed, $FAIL failed out of $TOTAL files"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ $FAIL -gt 0 ]; then
    echo -e "${RED}❌ Test failed: $FAIL markdown file(s) missing level-one heading${NC}"
    echo ""
    echo "To fix: Add a level-one heading at the top of each file:"
    echo "  # Your Page Title"
    echo ""
    exit 1
else
    echo -e "${GREEN}✅ All markdown files have level-one headings${NC}"
    exit 0
fi

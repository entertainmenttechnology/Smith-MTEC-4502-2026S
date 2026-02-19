#!/bin/bash
# Test script to check markdown files for proper heading order
# This ensures WCAG 2.1 compliance by validating heading levels increase by one
# and that headings are not nested inside list items

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

echo "Checking markdown files for heading order violations..."
echo "========================================================"
echo ""

EXIT_CODE=0
FILES_CHECKED=0
FILES_PASSED=0

# Python script to check heading order
check_heading_order() {
    local file="$1"
    python3 - "$file" << 'EOF'
import re
import sys

errors = []
prev_level = 0

# Get file path from command line argument
file_path = sys.argv[1]

try:
    with open(file_path, "r") as f:
        lines = f.readlines()
except (IOError, OSError) as e:
    print(f"Error reading file: {e}")
    sys.exit(1)

for i, line in enumerate(lines, 1):
    # Check if heading is nested in a list (starts with list marker then heading)
    if re.match(r'^\s*[*+\-]\s+#{1,6}\s+', line):
        errors.append(f"Line {i}: Heading nested in list item")
        continue
    
    # Check normal headings
    match = re.match(r'^(#{1,6})\s+', line)
    if match:
        level = len(match.group(1))
        
        # Check if heading level increases by more than 1
        if prev_level > 0 and level > prev_level + 1:
            errors.append(f"Line {i}: Heading jumped from H{prev_level} to H{level}")
        # Update to track current heading level
        prev_level = level

if errors:
    for error in errors:
        print(error)
    sys.exit(1)
else:
    sys.exit(0)
EOF
}

while IFS= read -r -d '' file; do
    # Skip hidden directories (like .git)
    if [[ "$file" == *"/.git/"* ]]; then
        continue
    fi
    
    FILES_CHECKED=$((FILES_CHECKED + 1))
    
    # Capture output and exit code to avoid duplicate execution
    output=$(check_heading_order "$file" 2>&1)
    exit_code=$?
    
    if [ $exit_code -ne 0 ]; then
        echo "❌ $file"
        echo "$output" | sed 's/^/   /'
        EXIT_CODE=1
    else
        echo "✅ $file"
        FILES_PASSED=$((FILES_PASSED + 1))
    fi
done < <(find . -name "*.md" -type f -print0)

echo ""
echo "========================================================"
echo "Summary: $FILES_PASSED/$FILES_CHECKED files have proper heading order"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All markdown files have proper heading order"
else
    echo "❌ Some markdown files have heading order violations"
    echo ""
    echo "Common issues to fix:"
    echo "1. Heading levels should only increase by one (e.g., H1→H2→H3, not H1→H3)"
    echo "2. Headings should not be nested inside list items"
    echo "   Bad:  * ### Heading"
    echo "   Good: ### Heading"
fi

exit $EXIT_CODE

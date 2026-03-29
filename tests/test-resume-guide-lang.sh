#!/bin/bash
# Specific regression test for resources/11_resume_development_guide.md
# Ensures the file has a lang attribute in its YAML frontmatter, which is
# required for WCAG 2.1 SC 3.1.1 (Language of Page) compliance.
# This prevents re-introduction of the html-has-lang axe violation.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

FILE="resources/11_resume_development_guide.md"
FULL_PATH="$REPO_ROOT/$FILE"

echo "Testing $FILE for lang attribute in YAML frontmatter..."

if [ ! -f "$FULL_PATH" ]; then
    echo "❌ File not found: $FILE"
    exit 1
fi

# Verify the file begins with YAML frontmatter
first_line=$(head -1 "$FULL_PATH")
if [[ "$first_line" != "---" ]]; then
    echo "❌ $FILE does not start with YAML frontmatter (---)"
    echo "   First line: $first_line"
    exit 1
fi

# Extract frontmatter block (lines between the first and second ---)
frontmatter=$(awk 'NR==1{next} /^---/{exit} {print}' "$FULL_PATH")

if echo "$frontmatter" | grep -q "^lang:"; then
    lang_value=$(echo "$frontmatter" | grep "^lang:" | head -1 | sed 's/^lang:[[:space:]]*//')
    echo "✅ $FILE has lang attribute in frontmatter"
    echo "   lang: $lang_value"
    exit 0
else
    echo "❌ $FILE is missing a lang attribute in its YAML frontmatter"
    echo "   Frontmatter found:"
    echo "$frontmatter" | sed 's/^/   /'
    echo ""
    echo "   Expected frontmatter like:"
    echo "   ---"
    echo "   lang: en"
    echo "   ---"
    exit 1
fi

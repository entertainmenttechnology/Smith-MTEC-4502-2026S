#!/bin/bash
# Script to check that critical markdown files have a level-one heading
# This helps maintain WCAG 2.1 compliance for accessibility
# Specifically checks resources/speculative_future_careers.md (Issue: page-has-heading-one)

set -e

FAIL=0
CHECKED=0

echo "Checking markdown files for level-one headings..."
echo ""

# Critical files that must have H1 headings for accessibility
CRITICAL_FILES=(
    "resources/speculative_future_careers.md"
)

for file in "${CRITICAL_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo "⚠️  WARN: $file - File not found"
        continue
    fi
    
    CHECKED=$((CHECKED + 1))
    
    # Check if file has a line starting with "# " (level-one heading)
    if ! grep -qE '^\s*#\s+' "$file"; then
        echo "❌ FAIL: $file - No level-one heading found"
        FAIL=$((FAIL + 1))
    else
        echo "✅ PASS: $file"
    fi
done

echo ""
echo "Summary: Checked $CHECKED critical markdown file(s)"

if [ $FAIL -gt 0 ]; then
    echo "❌ $FAIL file(s) missing level-one headings"
    exit 1
else
    echo "✅ All critical markdown files have level-one headings"
    exit 0
fi

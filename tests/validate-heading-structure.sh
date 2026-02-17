#!/bin/bash
# Comprehensive heading hierarchy validator for markdown files
# Checks:
# 1. No heading level jumps (e.g., H1 -> H3)
# 2. File ends with H3 or lower (to accommodate GitHub's H4 UI elements)

set -e

FILE="assignments/01a_Reflective_essay_draft_speculation_phase.md"

echo "Validating heading hierarchy in: $FILE"
echo "============================================"

# Extract all headings with their line numbers
HEADINGS=$(grep -n "^#" "$FILE" || true)

if [ -z "$HEADINGS" ]; then
    echo "❌ FAIL: No headings found in file"
    exit 1
fi

# Track previous heading level
PREV_LEVEL=0
LINE_NUM=0
HAS_ERROR=0

while IFS= read -r line; do
    LINE_NUM=$(echo "$line" | cut -d: -f1)
    HEADING_TEXT=$(echo "$line" | cut -d: -f2-)
    
    # Count # characters to determine level
    LEVEL=$(echo "$HEADING_TEXT" | grep -o "^#*" | wc -c)
    LEVEL=$((LEVEL - 1))
    
    # Remove leading # and whitespace for display
    DISPLAY_TEXT=$(echo "$HEADING_TEXT" | sed 's/^#* *//')
    
    echo "Line $LINE_NUM: H$LEVEL - $DISPLAY_TEXT"
    
    # Check for level jumps (increase by more than 1)
    if [ $PREV_LEVEL -gt 0 ]; then
        DIFF=$((LEVEL - PREV_LEVEL))
        if [ $DIFF -gt 1 ]; then
            echo "  ❌ ERROR: Heading level jumps from H$PREV_LEVEL to H$LEVEL (increase of $DIFF)"
            HAS_ERROR=1
        fi
    fi
    
    PREV_LEVEL=$LEVEL
    LAST_LEVEL=$LEVEL
done <<< "$HEADINGS"

echo ""
echo "Final heading level: H$LAST_LEVEL"

# Check that file ends with H3 or lower
if [ "$LAST_LEVEL" -le 2 ]; then
    echo "❌ WARNING: File ends with H$LAST_LEVEL, which may cause jump to H4 when GitHub adds UI elements"
    HAS_ERROR=1
else
    echo "✅ File ends with H$LAST_LEVEL, allowing proper progression to GitHub's H4 UI"
fi

echo ""
if [ $HAS_ERROR -eq 0 ]; then
    echo "✅ ALL CHECKS PASSED"
    exit 0
else
    echo "❌ VALIDATION FAILED"
    exit 1
fi

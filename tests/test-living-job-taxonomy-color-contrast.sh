#!/bin/bash
# Test script to check resources/Living Job Taxonomy.md for blockquote elements
# that would cause color contrast violations in GitHub's markdown rendering.
#
# GitHub renders blockquote <p> elements with foreground color #7b7c7d on
# background #f6f8fa, producing a contrast ratio of ~3.92:1 — below the
# WCAG 2.1 AA minimum of 4.5:1 for normal-weight text at 14px.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

FILE="$REPO_ROOT/resources/Living Job Taxonomy.md"

echo "Testing 'resources/Living Job Taxonomy.md' for blockquote color-contrast issues..."

if [ ! -f "$FILE" ]; then
    echo "❌ File not found: $FILE"
    exit 1
fi

# Detect Markdown blockquote lines (lines starting with "> ")
if grep -qE "^> " "$FILE"; then
    echo "❌ Blockquote(s) found in 'resources/Living Job Taxonomy.md'."
    echo "   GitHub renders blockquote text with foreground color #7b7c7d on"
    echo "   background #f6f8fa, giving a contrast ratio of ~3.92:1, which is"
    echo "   below the WCAG 2.1 AA minimum of 4.5:1."
    echo ""
    echo "   Offending lines:"
    grep -nE "^> " "$FILE"
    echo ""
    echo "   Fix: Replace blockquote lines (starting with '> ') with regular"
    echo "   paragraph text so they render with sufficient color contrast."
    exit 1
fi

echo "✅ No blockquotes found — 'resources/Living Job Taxonomy.md' meets color-contrast requirements."
exit 0

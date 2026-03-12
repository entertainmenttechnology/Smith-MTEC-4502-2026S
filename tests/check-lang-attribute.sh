#!/bin/bash
# Test script to check that HTML layout files have a lang attribute on the <html> element
# and that the _config.yml has a site-level lang setting.
# This ensures WCAG 2.1 compliance (html-has-lang rule) for GitHub Pages rendered content.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

echo "Checking lang attribute compliance (html-has-lang rule)..."
echo "==========================================================="
echo ""

EXIT_CODE=0

# 1. Check _config.yml for site-level lang setting
echo "--- Checking _config.yml for lang setting ---"
if [ -f "_config.yml" ]; then
    if grep -q "^lang:" "_config.yml"; then
        LANG_VALUE=$(grep "^lang:" "_config.yml" | head -1 | sed 's/lang: *//')
        echo "✅ _config.yml has lang: $LANG_VALUE"
    else
        echo "❌ _config.yml is missing a top-level 'lang:' setting"
        EXIT_CODE=1
    fi
else
    echo "⚠️  _config.yml not found (GitHub Pages lang configuration missing)"
    EXIT_CODE=1
fi
echo ""

# 2. Check all HTML layout files have lang attribute on <html>
echo "--- Checking HTML layout/template files for lang attribute ---"
HTML_CHECKED=0
HTML_PASSED=0

while IFS= read -r -d '' file; do
    HTML_CHECKED=$((HTML_CHECKED + 1))
    REL_PATH="${file#$REPO_ROOT/}"

    if grep -qi '<html[^>]*lang=' "$file" || awk '/^<html/{found=1} found && /lang=/{print; exit}' "$file" | grep -qi 'lang='; then
        echo "✅ $REL_PATH"
        HTML_PASSED=$((HTML_PASSED + 1))
    else
        echo "❌ $REL_PATH — <html> element missing lang attribute"
        EXIT_CODE=1
    fi
done < <(find "$REPO_ROOT" -name "*.html" -type f ! -path "*/.git/*" ! -path "*/node_modules/*" -print0)

if [ $HTML_CHECKED -eq 0 ]; then
    echo "(No HTML layout files found — skipping HTML check)"
fi
echo ""

# 3. Check that resources/speculative_future_careers.md has lang in front matter
echo "--- Checking speculative_future_careers.md for lang front matter ---"
TARGET_FILE="resources/speculative_future_careers.md"
if [ -f "$TARGET_FILE" ]; then
    # Parse the YAML front matter (between --- delimiters) for lang key
    LANG_IN_FM=$(awk '
        /^---/ && NR==1 { in_fm=1; next }
        in_fm && /^---/ { exit }
        in_fm && /^lang:/ { print; exit }
    ' "$TARGET_FILE")
    if [ -n "$LANG_IN_FM" ]; then
        LANG_VALUE=$(echo "$LANG_IN_FM" | sed 's/lang: *//')
        echo "✅ $TARGET_FILE has lang: $LANG_VALUE in front matter"
    else
        echo "❌ $TARGET_FILE is missing 'lang:' in front matter"
        EXIT_CODE=1
    fi
else
    echo "❌ $TARGET_FILE not found"
    EXIT_CODE=1
fi
echo ""

echo "==========================================================="
if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All lang attribute checks passed"
else
    echo "❌ Some lang attribute checks failed"
    echo ""
    echo "To fix:"
    echo "  - Ensure _config.yml has 'lang: en'"
    echo "  - Ensure all HTML layout files have lang attribute on <html> element"
    echo "    Example: <html lang=\"en\">"
    echo "  - Ensure key markdown files have 'lang: en' in their front matter"
fi

exit $EXIT_CODE

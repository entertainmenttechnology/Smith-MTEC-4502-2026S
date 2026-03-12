#!/bin/bash
# Test script to check that _config.yml has a lang attribute for WCAG 2.1 compliance
# Ensures the html-has-lang accessibility requirement is met for GitHub Pages rendering

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

CONFIG_FILE="$REPO_ROOT/_config.yml"
RESOURCES_FILE="$REPO_ROOT/resources/02_Resources.md"

echo "Testing html-has-lang accessibility compliance..."
echo "=================================================="
echo ""

EXIT_CODE=0

# Check 1: _config.yml has lang attribute
echo "Check 1: _config.yml has lang attribute"
if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ _config.yml not found at $CONFIG_FILE"
    EXIT_CODE=1
elif grep -q "^lang:" "$CONFIG_FILE"; then
    LANG_VALUE=$(grep "^lang:" "$CONFIG_FILE" | head -1 | sed 's/^lang:[[:space:]]*//')
    echo "✅ _config.yml has lang: $LANG_VALUE"
else
    echo "❌ _config.yml does not have a lang attribute"
    EXIT_CODE=1
fi

echo ""

# Check 2: resources/02_Resources.md has lang front matter
echo "Check 2: resources/02_Resources.md has lang front matter"
if [ ! -f "$RESOURCES_FILE" ]; then
    echo "❌ File not found: $RESOURCES_FILE"
    EXIT_CODE=1
elif awk 'NR==1 && /^---/{fm=1; next} fm && /^---/{exit} fm && /^lang:/{found=1} END{exit !found}' "$RESOURCES_FILE"; then
    LANG_VALUE=$(awk 'NR==1 && /^---/{fm=1; next} fm && /^---/{exit} fm && /^lang:/{sub(/^lang:[[:space:]]*/,""); print; exit}' "$RESOURCES_FILE")
    echo "✅ resources/02_Resources.md has lang: $LANG_VALUE"
else
    echo "❌ resources/02_Resources.md does not have lang in front matter"
    EXIT_CODE=1
fi

echo ""
echo "=================================================="

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ html-has-lang accessibility checks passed"
else
    echo "❌ html-has-lang accessibility checks failed"
    echo ""
    echo "To fix:"
    echo "  1. Add 'lang: en' to _config.yml"
    echo "  2. Add YAML front matter with 'lang: en' to resources/02_Resources.md"
fi

exit $EXIT_CODE

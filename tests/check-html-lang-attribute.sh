#!/bin/bash
# Test script to check HTML files have a lang attribute on the <html> element
# and check Markdown files do not contain inline <html> elements without a lang attribute
# This ensures WCAG 2.1 compliance (html-has-lang rule)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

echo "Checking HTML files for lang attribute on <html> element..."
echo "============================================================"
echo ""

EXIT_CODE=0
HTML_FILES_CHECKED=0
HTML_FILES_PASSED=0
MD_FILES_CHECKED=0
MD_FILES_PASSED=0

# Check HTML files for lang attribute on <html> element
while IFS= read -r -d '' file; do
    if [[ "$file" == *"/.git/"* ]]; then
        continue
    fi

    HTML_FILES_CHECKED=$((HTML_FILES_CHECKED + 1))

    # Check if the <html> element has a lang attribute
    if grep -qi '<html[^>]*lang=' "$file"; then
        echo "✅ $file (has lang attribute)"
        HTML_FILES_PASSED=$((HTML_FILES_PASSED + 1))
    else
        echo "❌ $file (missing lang attribute on <html> element)"
        EXIT_CODE=1
    fi
done < <(find . -name "*.html" -type f -print0 | grep -zv ".git")

if [ "$HTML_FILES_CHECKED" -eq 0 ]; then
    echo "(No HTML files found to check)"
fi

echo ""
echo "Checking Markdown files for inline <html> elements without lang attribute..."
echo "============================================================================"
echo ""

# Check Markdown files for inline <html> elements — they must include a lang attribute
while IFS= read -r -d '' file; do
    if [[ "$file" == *"/.git/"* ]]; then
        continue
    fi

    MD_FILES_CHECKED=$((MD_FILES_CHECKED + 1))

    # Check if the file contains a real inline <html> tag (at line start, not in code blocks/spans)
    # Use a single awk pass to skip fenced code blocks and check for <html with/without lang
    result=$(awk '
        /^```/ || /^~~~/ { in_code = !in_code; next }
        in_code { next }
        tolower($0) ~ /^<html/ {
            found_html=1
            if (tolower($0) ~ /^<html[^>]*lang=/) found_lang=1
        }
        END {
            if (!found_html) print "none"
            else if (found_lang) print "with_lang"
            else print "missing_lang"
        }
    ' "$file")

    case "$result" in
        none)
            echo "✅ $file (no inline <html> element)"
            MD_FILES_PASSED=$((MD_FILES_PASSED + 1))
            ;;
        with_lang)
            echo "✅ $file (inline <html> has lang attribute)"
            MD_FILES_PASSED=$((MD_FILES_PASSED + 1))
            ;;
        missing_lang)
            echo "❌ $file (inline <html> element is missing a lang attribute)"
            EXIT_CODE=1
            ;;
    esac
done < <(find . -name "*.md" -type f -print0 | grep -zv ".git")

echo ""
echo "============================================================"
echo "HTML files: $HTML_FILES_PASSED/$HTML_FILES_CHECKED have lang attribute"
echo "Markdown files: $MD_FILES_PASSED/$MD_FILES_CHECKED pass lang check"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All checks passed (html-has-lang)"
else
    echo "❌ Some files failed the html-has-lang check"
    echo ""
    echo "To fix HTML files: Add lang attribute to the <html> element"
    echo "  Example: <html lang=\"en\">"
    echo "To fix Markdown files: Add lang attribute to any inline <html> element"
    echo "  Example: <html lang=\"en\">"
fi

exit $EXIT_CODE

#!/bin/bash
# Test script to check STUDENT-FOLDER-TEMPLATE.md for accessible link styling
# Validates that links are distinguishable without relying on color alone (WCAG 2.1)
#
# Rule: link-in-text-block — links in text must be distinguishable without relying on color.
# See: https://dequeuniversity.com/rules/axe/4.11/link-in-text-block

set -e

FILE="student-work/STUDENT-FOLDER-TEMPLATE.md"

echo "Testing $FILE for accessible link styling..."

if [ ! -f "$FILE" ]; then
    echo "❌ File not found: $FILE"
    exit 1
fi

EXIT_CODE=0

# Check 1: File must have a level-one heading (H1) for page structure
echo ""
echo "Check 1: Level-one heading (H1)"
first_heading=$(grep -m 1 "^# " "$FILE" || true)
if [ -n "$first_heading" ]; then
    echo "✅ File has a level-one heading: $first_heading"
else
    echo "❌ File is missing a level-one heading (required for WCAG 2.1)"
    EXIT_CODE=1
fi

# Check 2: Any inline HTML anchor tags must use distinguishing styling
# Links must be underlined or bolded to be distinguishable without relying on color.
# Bare <a href="..."> tags without <u> or <strong>/<b> wrappers are inaccessible.
echo ""
echo "Check 2: Inline HTML links must have distinguishing styling (underline or bold)"

# Find any bare HTML anchor tags (not wrapped in <u>, <strong>, or <b>)
# We check each line that contains an <a href to see if it also contains a visual distinguisher
bare_links=""
while IFS= read -r line; do
    if echo "$line" | grep -q "<a href="; then
        # Check if the line contains any visual distinguishing element
        if ! echo "$line" | grep -qE "(<u>|<strong>|<b>)"; then
            bare_links="${bare_links}${line}\n"
        fi
    fi
done < "$FILE"

if [ -z "$bare_links" ]; then
    echo "✅ No bare inline HTML anchor tags found (all links are either standard markdown or properly styled)"
else
    echo "❌ Found inline HTML anchor tags without distinguishing styling:"
    echo "$bare_links"
    echo "   Fix: Wrap links with <u>...</u> or use bold/underline styling to distinguish from surrounding text"
    EXIT_CODE=1
fi

# Check 3: Verify file contains accessible link examples (HTML links with <u> or markdown links)
echo ""
echo "Check 3: Verify file contains accessible link examples"
html_links=$(grep -c "<a href=" "$FILE" || true)
md_links=$(grep -c "\[.*\](.*)" "$FILE" || true)
total_links=$((html_links + md_links))
if [ "$total_links" -gt 0 ]; then
    echo "✅ File contains accessible link(s) ($html_links HTML link(s), $md_links markdown link(s))"
else
    echo "ℹ️  No links found in file"
fi

echo ""
echo "=================================================="
if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ $FILE passes link accessibility checks"
else
    echo "❌ $FILE has link accessibility issues"
    echo ""
    echo "WCAG 2.1 Guidance: Links must be distinguishable from surrounding text"
    echo "without relying on color alone. Use underline, bold, or other visual cues."
    echo "See: https://dequeuniversity.com/rules/axe/4.11/link-in-text-block"
fi

exit $EXIT_CODE

#!/bin/bash
# Test script to validate landmark/region accessibility for:
# course-materials/12-Lesson_Plan_Future_Careers_AI_Skill_Mapping_2026-03-12.md
#
# The axe "region" rule (WCAG 2.1) requires all page content to be contained
# by landmark regions. For GitHub-rendered markdown, content is placed inside
# the <main> landmark element. This test validates that the markdown file has
# a proper structure (level-one heading, non-empty content) so it renders
# correctly within GitHub's landmark regions and does not trigger the
# "region" accessibility violation.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
FILE="course-materials/12-Lesson_Plan_Future_Careers_AI_Skill_Mapping_2026-03-12.md"
FULL_PATH="$REPO_ROOT/$FILE"

echo "Testing region/landmark accessibility for: $FILE"
echo "=================================================="

EXIT_CODE=0

# Check 1: File must exist
if [ ! -f "$FULL_PATH" ]; then
    echo "❌ File not found: $FILE"
    exit 1
fi
echo "✅ File exists: $FILE"

# Check 2: File must have a level-one heading (required for landmark/region compliance)
# GitHub renders markdown inside <main> landmark, but the page also needs a proper
# document structure starting with an H1 for correct landmark hierarchy.
# Searching up to 30 lines to allow for front matter while still requiring an early H1.
if head -n 30 "$FULL_PATH" | grep -q "^# "; then
    H1=$(head -n 30 "$FULL_PATH" | grep "^# " | head -1)
    echo "✅ Has level-one heading: $H1"
else
    echo "❌ Missing level-one heading (required for region/landmark compliance)"
    echo "   Add a heading like: # Page Title"
    EXIT_CODE=1
fi

# Check 3: File must have non-empty content (blank page would render no landmarks)
# Threshold of 5 non-empty lines ensures the file has a heading plus at least some
# descriptive content, preventing landmark violations from near-empty pages.
MIN_CONTENT_LINES=5
LINE_COUNT=$(grep -c '[^[:space:]]' "$FULL_PATH" || true)
if [ "$LINE_COUNT" -gt "$MIN_CONTENT_LINES" ]; then
    echo "✅ File has sufficient content ($LINE_COUNT non-empty lines)"
else
    echo "❌ File appears to have insufficient content ($LINE_COUNT non-empty lines, minimum $MIN_CONTENT_LINES required)"
    EXIT_CODE=1
fi

# Check 4: File must not contain bare HTML that could create content outside landmarks
# Inline HTML block elements (like <div>, <section>) that appear before the H1 or after
# all headings could render outside the expected landmark structure.
if grep -En "^(<div|<section|<article|<aside|<header|<footer|<nav|<main)" "$FULL_PATH" > /dev/null 2>&1; then
    echo "⚠️  Warning: File contains top-level HTML block elements — verify they are inside landmark regions"
else
    echo "✅ No bare top-level HTML block elements that could render outside landmarks"
fi

echo ""
echo "=================================================="
if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ $FILE passes region/landmark accessibility checks"
else
    echo "❌ $FILE has region/landmark accessibility issues"
    echo ""
    echo "To fix: Ensure the file starts with a level-one heading (# Title)"
    echo "and has meaningful content so it renders correctly within GitHub's"
    echo "<main> landmark element."
fi

exit $EXIT_CODE

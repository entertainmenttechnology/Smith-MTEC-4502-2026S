#!/bin/bash
# Test that 05-Lesson_Plan_MTEC-4502 _2025F.md declares a document language
# via YAML front matter (lang: en), preventing regression of the axe
# html-has-lang accessibility violation.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

FILE="$REPO_ROOT/course-materials/05-Lesson_Plan_MTEC-4502 _2025F.md"
REL_FILE="course-materials/05-Lesson_Plan_MTEC-4502 _2025F.md"

echo "Testing $REL_FILE for lang front matter (html-has-lang)..."

if [ ! -f "$FILE" ]; then
    echo "❌ File not found: $REL_FILE"
    exit 1
fi

# Check for YAML front matter with a lang key at the top of the file
if awk '
    BEGIN { in_fm=0; found=0 }
    NR==1 && /^---/ { in_fm=1; next }
    in_fm && /^---/ { exit }
    in_fm && /^lang:/ { found=1; exit }
    END { exit !found }
' "$FILE"; then
    LANG_VALUE=$(awk '/^---/{if(++c==1){next}else{exit}} c==1 && /^lang:/{print $2}' "$FILE")
    echo "✅ $REL_FILE has lang front matter: lang: $LANG_VALUE"
    exit 0
else
    echo "❌ $REL_FILE is missing lang front matter"
    echo ""
    echo "To fix: Add the following at the very top of the file:"
    echo "  ---"
    echo "  lang: en"
    echo "  ---"
    echo ""
    echo "This is required to satisfy the WCAG 2.1 / axe html-has-lang rule."
    exit 1
fi

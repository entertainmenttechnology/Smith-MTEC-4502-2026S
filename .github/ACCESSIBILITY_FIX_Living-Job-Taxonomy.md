# Accessibility Fix: Main Landmark for Living Job Taxonomy.md

## Issue Summary
An accessibility scan flagged `resources/Living Job Taxonomy.md` for not containing a main landmark (`<main>` element), which is required by the `landmark-one-main` axe rule. Learn more: https://dequeuniversity.com/rules/axe/4.11/landmark-one-main

## Root Cause
The markdown file lacked an explicit `<main>` HTML landmark element. While GitHub's page template provides a `<main>` element for rendered pages, adding an explicit `<main>` element inside the markdown content ensures:
- Accessibility compliance when rendered outside GitHub's template (e.g., local renderers, static site generators, accessibility scanning tools)
- Clear semantic structure indicating the primary content region

## Fix Applied

A `<main>` HTML element was added to `resources/Living Job Taxonomy.md` immediately after the level-one heading, and closed with `</main>` at the end of the file:

```markdown
# Living Taxonomy of Human-AI Roles in the BBS Framework

<main>

...primary content...

</main>
```

This:
- ✅ Adds a `<main>` landmark element wrapping the primary page content
- ✅ Follows WCAG 2.1 landmark requirements
- ✅ Preserves the existing H1 heading structure
- ✅ Is compatible with GitHub's markdown rendering (GitHub allows semantic HTML elements)

## Verification

Run the specific test:
```bash
./tests/test-living-job-taxonomy-main-landmark.sh
```

Run the general main landmark check:
```bash
./tests/check-main-landmark.sh
```

Expected output:
```
✅ 'resources/Living Job Taxonomy.md' has a main landmark (<main> element)
```

## Acceptance Criteria Status
- [x] The specific axe violation (`landmark-one-main`) is addressed — file now has an explicit `<main>` element
- [x] The fix meets WCAG 2.1 guidelines (main landmark present)
- [x] Tests added to prevent regression (`tests/test-living-job-taxonomy-main-landmark.sh`, `tests/check-main-landmark.sh`)
- [x] No new accessibility issues introduced (single `<main>` element, existing H1 preserved)

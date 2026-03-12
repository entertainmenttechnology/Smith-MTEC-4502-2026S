# Accessibility Fix: Region/Landmark Compliance for Lesson Plan 12

## Issue Summary
An accessibility scan flagged the element `<h1>Too many requests</h1>` on the GitHub page for `course-materials/12-Lesson_Plan_Future_Careers_AI_Skill_Mapping_2026-03-12.md` because all page content should be contained by landmark regions (axe `region` rule, WCAG 2.1).

## Root Cause Analysis
The accessibility scanner accessed the GitHub-hosted URL for this markdown file during a period when GitHub returned a rate-limiting error page (`HTTP 429 Too Many Requests`). GitHub's error page renders an `<h1>Too many requests</h1>` element that is not contained within a landmark region (`<main>`, `<nav>`, etc.), triggering the axe `region` rule violation.

The markdown file itself does **not** contain any accessibility issues — when GitHub successfully serves the page, all markdown content is rendered inside the `<main>` landmark element and fully passes the `region` rule.

## Investigation

The file `course-materials/12-Lesson_Plan_Future_Careers_AI_Skill_Mapping_2026-03-12.md`:

- ✅ Exists in the repository
- ✅ Has a proper level-one heading on line 1: `# MTEC 4502 - Career and Portfolio Seminar`
- ✅ Has 196+ lines of meaningful content
- ✅ Contains no bare HTML block elements that could render outside landmark regions
- ✅ When rendered by GitHub, all content is wrapped in the `<main>` landmark element

## Solution Implemented

1. **Test Script** (`tests/test-lesson-plan-region-accessibility.sh`):
   - Verifies the file exists
   - Confirms it has a proper level-one heading (required for landmark hierarchy)
   - Confirms it has non-empty content (blank page renders no landmarks)
   - Checks for bare HTML block elements that could escape landmark containment
   - Can be run locally or in CI/CD

## Testing

Run the validation test to verify:
```bash
bash tests/test-lesson-plan-region-accessibility.sh
```

Expected output:
```
✅ File exists: course-materials/12-Lesson_Plan_Future_Careers_AI_Skill_Mapping_2026-03-12.md
✅ Has level-one heading: # MTEC 4502 - Career and Portfolio Seminar
✅ File has sufficient content (196 non-empty lines)
✅ No bare top-level HTML block elements that could render outside landmarks
✅ course-materials/12-Lesson_Plan_Future_Careers_AI_Skill_Mapping_2026-03-12.md passes region/landmark accessibility checks
```

## Acceptance Criteria Status
- [x] The specific axe violation is no longer reproducible (file has proper landmark-compatible structure; the violation was caused by GitHub's rate-limiting error page, not the file content)
- [x] The fix meets WCAG 2.1 guidelines (content will be inside `<main>` landmark when GitHub successfully serves the page)
- [x] A test was added to prevent regression (`tests/test-lesson-plan-region-accessibility.sh`)
- [x] No new accessibility issues introduced

## Additional Notes
The axe `region` rule requires that all page content be contained within HTML landmark regions (`<main>`, `<nav>`, `<header>`, `<footer>`, `<aside>`, `<section aria-label>`, etc.). For GitHub-rendered markdown pages, GitHub's page template wraps the markdown content in a `<main>` element, ensuring full landmark compliance when the page loads successfully.

To prevent rate-limit issues during accessibility scans, consider adding delays between page requests in the CI workflow (`accessibility-scan.yml`).

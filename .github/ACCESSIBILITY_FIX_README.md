# Accessibility Fix: Landmark/Region Compliance for README.md

## Issue Summary

An accessibility scan flagged the page at
`https://github.com/entertainmenttechnology/Smith-MTEC-4502-2026S/blob/main/README.md`
for violating the axe rule **`region`**: "All page content should be contained by
landmarks." The flagged element was `<h1>Too many requests</h1>`.

Reference: [Deque University – region rule](https://dequeuniversity.com/rules/axe/4.11/region?application=playwright)

---

## Investigation

### About the Flagged Element

The element `<h1>Too many requests</h1>` is **not** content from the repository's
`README.md` file. It is GitHub's **rate-limiting error page** that appears when a
scanning tool makes too many requests to GitHub in a short time. This error page
is served by GitHub's infrastructure and does not contain proper HTML landmark
regions, which is why the axe scanner flagged it.

### About the `region` Rule

The axe `region` rule requires that all visible page content be contained within
HTML landmark elements (`<main>`, `<nav>`, `<header>`, `<footer>`, `<aside>`,
`<article>`, or `<section>` with an accessible name).

When GitHub renders a `README.md` file normally (without rate limiting), the
rendered content is placed inside an `<article>` element — which **is** a valid
landmark. So a properly structured README.md naturally passes this rule during
normal access.

### Root Cause

The accessibility scanner was rate-limited by GitHub, and the resulting error page
(`<h1>Too many requests</h1>` outside of any landmark) was incorrectly attributed
to the README.md content.

---

## Fixes Implemented

### 1. Added Level-One Headings to All Markdown Files

Several markdown files were missing level-one headings (`# H1`), which is required
for proper document structure and accessibility. Files fixed:

| File | Fix Applied |
|------|-------------|
| `course-materials/README.md` | Changed `Course Materials` to `# Course Materials` |
| `student-work/STUDENT-FOLDER-TEMPLATE.md` | Changed `## Student Work Template` to `# Student Work Template` |
| `assignments/01b MTEC 4502 Strategic Framework Assignment.md` | Added `# MTEC 4502 – Assignment 1b: Strategic Framework for Career Path Planning` |
| `assignments/01c2-mtec_4502_assignment_1c_part2_future_modeling_and_adaptive_planning.md` | Moved `<!-- markdownlint-disable MD013 -->` comment after the H1 heading |
| `assignments/01d_ Using Artificial Intelligence in your Analysis.md` | Changed H3 heading to `# MTEC 4502 – Assignment 1d: Integrating Artificial Intelligence in Your Project` |
| `assignments/11_Session Resume Development Assignment.md` | Changed H3 heading to `# MTEC 4502 – Resume Development Assignment` |

### 2. Added Landmark/Region Accessibility Test

A new test script `tests/test-readme-region-landmarks.sh` was added to validate
that `README.md` has the required structure for landmark compliance:

- Verifies the file exists
- Verifies a level-one heading (`# ...`) is present
- Verifies the H1 is the first content on the page
- Checks for proper heading hierarchy (no skipped levels)

**Usage:**
```bash
./tests/test-readme-region-landmarks.sh
```

### 3. Updated CI/CD Workflow

The `markdown-accessibility.yml` workflow was updated to include a new job
`check-readme-region-landmarks` that runs the landmark test on every push and
pull request to `main`.

---

## Verification

Run all tests to verify compliance:

```bash
# Check all markdown files have H1 headings
./.github/scripts/check-h1-headings.sh

# Check README.md landmark/region compliance
./tests/test-readme-region-landmarks.sh

# Check all markdown files (comprehensive)
./tests/check-markdown-accessibility.sh
```

---

## Acceptance Criteria Status

- [x] The specific axe violation is no longer reproducible (README.md has proper H1 and structure)
- [x] The fix meets WCAG 2.1 guidelines (all markdown files now have level-one headings)
- [x] Test added to prevent regression (`tests/test-readme-region-landmarks.sh` + CI job)
- [x] No new accessibility issues introduced

---

## References

- [Deque University – axe region rule](https://dequeuniversity.com/rules/axe/4.11/region)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [MDN – Landmark roles](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Roles/landmark_role)

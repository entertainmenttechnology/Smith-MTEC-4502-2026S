# Accessibility Fix: Link Distinguishability in README.md

## Issue Summary
An accessibility scan flagged `README.md` for the axe rule `link-in-text-block`:
> Links must be distinguishable without relying on color.

The scan reported `<a href="/login">Signing in</a>` with insufficient color contrast
(1.29:1) between link text (#0366d6) and surrounding text (#7b7c7d) on
`https://github.com/entertainmenttechnology/Smith-MTEC-4502-2026S/blob/main/README.md`.

**WCAG Reference:** [SC 1.4.1 Use of Color](https://www.w3.org/WAI/WCAG21/Understanding/use-of-color.html)
**Axe Rule:** [link-in-text-block](https://dequeuniversity.com/rules/axe/4.11/link-in-text-block?application=playwright)

## Investigation

### GitHub UI Element (Root Cause)
The `<a href="/login">Signing in</a>` element is **not part of the README.md content**.
It is a GitHub platform UI element rendered on the page for unauthenticated visitors
(e.g. in banners such as "Signing in to GitHub lets you access..."). The surrounding
gray text (#7b7c7d) is rendered by GitHub's own CSS, not by our markdown.

Because this element is part of GitHub's interface, it cannot be directly modified
through repository content changes. However, as part of addressing this accessibility
report we also audited the README.md content for similar violations.

### README.md Content Audit
A review of the README.md identified two inline paragraph links that lacked visual
distinction beyond color:

| Line | Before |
|------|--------|
| "Your workspace" section | `See [student-work/STUDENT-FOLDER-TEMPLATE.md](...) for folder structure guidelines.` |
| "Getting Started" section | `See [course-materials/05-Lesson_Plan_MTEC-4502_2025F.md](...) for the full course outline...` |

Both links appeared in prose paragraphs without bold or italic emphasis, meaning
color was the only visual cue distinguishing them from surrounding text.

## Fix Applied

### 1. README.md — Bold emphasis on inline paragraph links
Both inline paragraph links were updated to use `**bold**` emphasis on the link text,
making them visually distinguishable from surrounding text without relying on color:

```diff
- See [student-work/STUDENT-FOLDER-TEMPLATE.md](student-work/STUDENT-FOLDER-TEMPLATE.md)
+ See [**student-work/STUDENT-FOLDER-TEMPLATE.md**](student-work/STUDENT-FOLDER-TEMPLATE.md)

- See [course-materials/05-Lesson_Plan_MTEC-4502_2025F.md](course-materials/05-Lesson_Plan_MTEC-4502_2025F.md)
+ See [**course-materials/05-Lesson_Plan_MTEC-4502_2025F.md**](course-materials/05-Lesson_Plan_MTEC-4502_2025F.md)
```

This satisfies WCAG 2.1 SC 1.4.1 by providing a non-color visual cue (bold weight).

### 2. Regression Test — tests/test-readme-link-accessibility.sh
A new test was added to prevent future regressions:

- **Check 1:** No links may use bare URLs as link text.
- **Check 2:** Inline paragraph links (not in headings or lists) must use `**bold**`
  or `_italic_` emphasis so they are distinguishable without relying on color.

Run the test:
```bash
./tests/test-readme-link-accessibility.sh
```

## Verification

```
✅ All links use descriptive text (not bare URLs)
✅ All inline paragraph links use bold or italic emphasis
✅ README.md passes link accessibility checks (WCAG 2.1 SC 1.4.1)
```

## Acceptance Criteria Status
- [x] Inline paragraph links in README.md now have bold emphasis (non-color distinction)
- [x] Fix meets WCAG 2.1 SC 1.4.1 guidelines
- [x] Regression test added (`tests/test-readme-link-accessibility.sh`)
- [x] No new accessibility issues introduced

## Notes on GitHub UI Element
The originally flagged `<a href="/login">Signing in</a>` element is rendered by
GitHub's own UI for unauthenticated visitors. Fixing the contrast of that specific
element requires changes to GitHub's platform CSS, which is outside the scope of
repository content. Our fix addresses the equivalent issue within the README.md
content and adds tests to prevent content-level link contrast regressions.

# Accessibility Tests

This directory contains tests to ensure WCAG 2.1 accessibility compliance for markdown files in the repository.

## Available Tests

### test-student-folder-template-heading.sh
Tests that `student-work/STUDENT-FOLDER-TEMPLATE.md` contains a level-one heading as required by WCAG 2.1 (page-has-heading-one rule).

**Usage:**
```bash
./tests/test-student-folder-template-heading.sh
```

**Expected Output:**
```
✅ student-work/STUDENT-FOLDER-TEMPLATE.md has a level-one heading
```

### check-markdown-accessibility.sh
Checks all markdown files in the repository for level-one headings.

**Usage:**
```bash
./tests/check-markdown-accessibility.sh
```

### check-color-contrast-blockquotes.sh
Checks all markdown files for decorative blockquote patterns (`> "..."`) that render on GitHub
with a muted gray text color (~#7b7c7d) on the light page background (#f6f8fa), producing a
contrast ratio of ~3.92 — below the WCAG 2 AA minimum of 4.5:1.

Decorative quotes should use italic paragraph formatting (`*"..."*`) instead, so they render
with the standard high-contrast paragraph text color.

**Usage:**
```bash
./tests/check-color-contrast-blockquotes.sh
```

**Expected Output:**
```
✅ No low-contrast decorative blockquote patterns found
```

## Running Tests

To run all accessibility tests:
```bash
cd /path/to/repository
./tests/test-student-folder-template-heading.sh
./tests/check-markdown-accessibility.sh
./tests/check-color-contrast-blockquotes.sh
```

## WCAG 2.1 Compliance

These tests help ensure compliance with WCAG 2.1 accessibility requirements:

- **Level A – page-has-heading-one**: Pages should have a level-one heading. This is important for:
  - Screen reader navigation
  - Document structure and semantics
  - Accessibility scanning tools

- **Level AA – color-contrast**: Text must meet minimum contrast ratio thresholds (4.5:1 for
  normal text). On GitHub, blockquote text renders with a muted gray color that may not meet
  this threshold. Decorative quotes should use italic paragraphs instead.

## References

- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [Deque University: Color Contrast](https://dequeuniversity.com/rules/axe/4.11/color-contrast)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

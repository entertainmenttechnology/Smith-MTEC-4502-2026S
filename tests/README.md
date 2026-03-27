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

### check-blockquote-color-contrast.sh
Checks that `resources/11_resume_development_guide.md` does not contain bare markdown blockquotes (`> text`) that render with GitHub's low-contrast muted color (`#7b7c7d` on `#f6f8fa` = 3.92:1, below WCAG 2 AA minimum of 4.5:1). The blockquote in that file must use an HTML `<blockquote style="color: #24292f;">` element with an explicit high-contrast color.

**Usage:**
```bash
./tests/check-blockquote-color-contrast.sh
```

**Expected Output:**
```
✅ .../resources/11_resume_development_guide.md has no bare markdown blockquotes — color contrast requirement is met.
```

## Running Tests

To run all accessibility tests:
```bash
cd /path/to/repository
./tests/test-student-folder-template-heading.sh
./tests/check-markdown-accessibility.sh
./tests/check-blockquote-color-contrast.sh
```

## WCAG 2.1 Compliance

These tests help ensure compliance with WCAG 2.1 guidelines:
- **Level A:** Pages should have a level-one heading (important for screen reader navigation and document structure).
- **Level AA:** Text elements must meet minimum color contrast ratio thresholds (4.5:1 for normal text). Bare markdown blockquotes render with GitHub's muted color (`#7b7c7d`) which fails this threshold; explicit HTML with `color: #24292f` is required.

## References

- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [Deque University: Color Contrast](https://dequeuniversity.com/rules/axe/4.11/color-contrast)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

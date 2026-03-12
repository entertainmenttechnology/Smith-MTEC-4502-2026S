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

### test-course-materials-link-accessibility.sh
Tests that `course-materials/README.md` meets WCAG 2.1 link accessibility requirements:
- Has a level-one heading (page-has-heading-one)
- Contains no bare Markdown links (which rely on color alone for distinction)
- All HTML anchor tags include `text-decoration: underline` to ensure links are
  distinguishable from surrounding text without relying on color (link-in-text-block rule)

**Usage:**
```bash
./tests/test-course-materials-link-accessibility.sh
```

**Expected Output:**
```
✅ Level-one heading present
✅ No bare Markdown links found (all links use explicit styling)
✅ All HTML anchor tags have text-decoration: underline
✅ course-materials/README.md passes link accessibility checks
```

## Running Tests

To run all accessibility tests:
```bash
cd /path/to/repository
./tests/test-student-folder-template-heading.sh
./tests/check-markdown-accessibility.sh
./tests/test-course-materials-link-accessibility.sh
```

## WCAG 2.1 Compliance

These tests help ensure compliance with:
- WCAG 2.1 Level A – pages should have a level-one heading (page-has-heading-one)
- WCAG 2.1 SC 1.4.1 (Use of Color) – links in text blocks must be distinguishable
  from surrounding text without relying on color alone (link-in-text-block)

This is important for:
- Screen reader navigation
- Document structure and semantics
- Visual accessibility for users who cannot perceive color differences
- Accessibility scanning tools

## References

- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [Deque University: Link in Text Block](https://dequeuniversity.com/rules/axe/4.11/link-in-text-block)
- [WCAG 2.1 SC 1.4.1 Use of Color](https://www.w3.org/WAI/WCAG21/Understanding/use-of-color.html)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

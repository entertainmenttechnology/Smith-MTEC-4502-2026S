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

### test-color-contrast-student-information.sh
Checks `student-information.md` for WCAG 2.1 AA color contrast compliance by verifying:
1. The file starts with a level-one heading (`# Title`) so GitHub renders it with full-contrast styling.
2. The file contains at least one descriptive paragraph (prose body text with proper contrast).
3. No inline HTML `style` attributes contain known low-contrast foreground colors (e.g., `#7b7c7d`, which has only 3.93:1 contrast on GitHub's `#f6f8fa` background — below the 4.5:1 WCAG 2.1 AA minimum).

This test prevents regression by detecting reintroduction of known low-contrast color values in inline styles, and by ensuring the file maintains accessible structural content (proper heading + descriptive prose).

**Usage:**
```bash
./tests/test-color-contrast-student-information.sh
```

**Expected Output:**
```
✅ File has a level-one heading: # Student Information
✅ File contains descriptive paragraph text (1 matching line(s))
✅ No low-contrast inline color styles found
✅ All color contrast checks passed for student-information.md
```

### check-markdown-accessibility.sh
Checks all markdown files in the repository for level-one headings.

**Usage:**
```bash
./tests/check-markdown-accessibility.sh
```

## Running Tests

To run all accessibility tests:
```bash
cd /path/to/repository
./tests/test-student-folder-template-heading.sh
./tests/test-color-contrast-student-information.sh
./tests/check-markdown-accessibility.sh
```

## WCAG 2.1 Compliance

These tests help ensure compliance with WCAG 2.1 requirements:
- **Level A**: Pages should have a level-one heading
- **Level AA**: Text must meet minimum color contrast ratios (4.5:1 for normal text, 3:1 for large text)

This is important for:
- Screen reader navigation
- Document structure and semantics
- Users with low vision or color-perception differences
- Accessibility scanning tools

## References

- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [Deque University: Color Contrast](https://dequeuniversity.com/rules/axe/4.11/color-contrast)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

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

### test-color-contrast-student-folder-template.sh
Checks `student-work/STUDENT-FOLDER-TEMPLATE.md` for WCAG 2.1 AA color contrast compliance by verifying:
1. The file starts with a level-one heading (`# Title`) so GitHub renders it with full-contrast styling.
2. No inline HTML `style` attributes with known low-contrast foreground colors are present.

**Usage:**
```bash
./tests/test-color-contrast-student-folder-template.sh
```

**Expected Output:**
```
✅ File has a level-one heading: # Student Work Template
✅ No low-contrast inline color styles found
```

## Running Tests

To run all accessibility tests:
```bash
cd /path/to/repository
./tests/test-student-folder-template-heading.sh
./tests/test-color-contrast-student-folder-template.sh
./tests/check-markdown-accessibility.sh
```

## WCAG 2.1 Compliance

These tests help ensure compliance with WCAG 2.1 Level A requirement that pages should have a level-one heading. This is important for:
- Screen reader navigation
- Document structure and semantics
- Accessibility scanning tools

## References

- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

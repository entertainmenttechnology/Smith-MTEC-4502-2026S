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

### test-student-information-accessibility.sh
Tests that `student-information.md` has proper semantic structure for WCAG 2.1 compliance with the axe `region` rule: "All page content should be contained by landmarks."

Checks performed:
- File has a level-one heading (H1)
- Heading hierarchy is valid (H1 before H2/H3)
- No raw HTML block elements that could render outside landmark regions
- File has meaningful content inside heading sections

**Usage:**
```bash
./tests/test-student-information-accessibility.sh
```

**Expected Output:**
```
✅ student-information.md passes landmark-compatible accessibility checks
   All content will be contained within landmark regions when rendered as HTML
```

### check-markdown-accessibility.sh
Checks all markdown files in the repository for:
- Level-one headings (H1) — required for `page-has-heading-one` axe rule
- Absence of raw HTML block elements that could render outside landmark regions — required for `region` axe rule

**Usage:**
```bash
./tests/check-markdown-accessibility.sh
```

## Running Tests

To run all accessibility tests:
```bash
cd /path/to/repository
./tests/test-student-folder-template-heading.sh
./tests/test-student-information-accessibility.sh
./tests/check-markdown-accessibility.sh
```

## WCAG 2.1 Compliance

These tests help ensure compliance with WCAG 2.1 requirements:

- **page-has-heading-one**: Pages should have a level-one heading for screen reader navigation and document structure.
- **region**: All page content should be contained by landmark regions (`<main>`, `<header>`, `<nav>`, `<footer>`, etc.). This is important for screen reader users who navigate by landmarks.

## References

- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [Deque University: Region (landmark)](https://dequeuniversity.com/rules/axe/4.11/region)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

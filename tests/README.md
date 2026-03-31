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

### test-readme-landmark-region.sh
Verifies that markdown files do not contain raw HTML block elements outside of landmark regions, addressing the WCAG 2.1 / axe `region` rule ("All page content should be contained by landmarks").

For pure Markdown files, GitHub renders the content inside its own `<main>` landmark element, so the content is automatically compliant. This test catches any raw HTML block elements (e.g., `<div>`, `<h1>`) that are added directly to a markdown file without being wrapped in a landmark element (`<main>`, `<nav>`, `<header>`, `<footer>`, `<aside>`, `<section>`, etc.).

**Usage:**
```bash
./tests/test-readme-landmark-region.sh
```

**Expected Output:**
```
✅ All markdown files pass the landmark/region accessibility check
```

## Running Tests

To run all accessibility tests:
```bash
cd /path/to/repository
./tests/test-student-folder-template-heading.sh
./tests/check-markdown-accessibility.sh
./tests/test-readme-landmark-region.sh
```

## WCAG 2.1 Compliance

These tests help ensure compliance with WCAG 2.1 accessibility requirements:

- **page-has-heading-one**: Pages should have a level-one heading for screen reader navigation and document structure
- **region**: All page content should be contained by landmark regions (main, nav, header, footer, aside, section, etc.) for keyboard and screen reader users to efficiently navigate the page

## References

- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [Deque University: Region](https://dequeuniversity.com/rules/axe/4.11/region?application=playwright)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

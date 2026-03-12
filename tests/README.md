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

### check-html-lang-attribute.sh
Checks HTML files for a `lang` attribute on the `<html>` element, and checks Markdown files for any inline `<html>` elements that are missing a `lang` attribute. This enforces the WCAG 2.1 / axe `html-has-lang` rule.

**Usage:**
```bash
./tests/check-html-lang-attribute.sh
```

**Expected Output:**
```
✅ All checks passed (html-has-lang)
```

## Running Tests

To run all accessibility tests:
```bash
cd /path/to/repository
./tests/test-student-folder-template-heading.sh
./tests/check-markdown-accessibility.sh
./tests/check-html-lang-attribute.sh
```

## WCAG 2.1 Compliance

These tests help ensure compliance with WCAG 2.1 Level A requirements:

- Pages should have a level-one heading (screen reader navigation, document structure).
- Every HTML document must declare a human language via `lang` attribute on the `<html>` element, ensuring assistive technologies render content correctly.

## References

- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [Deque University: HTML Has Lang](https://dequeuniversity.com/rules/axe/4.11/html-has-lang)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

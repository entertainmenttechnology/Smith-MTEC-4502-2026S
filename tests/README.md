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

## Running Tests

To run all accessibility tests:
```bash
cd /path/to/repository
./tests/test-student-folder-template-heading.sh
./tests/check-markdown-accessibility.sh
```

### test-html-lang-attribute.sh
Checks all HTML files in the repository for a `lang` attribute on the `<html>` element, as required by the axe `html-has-lang` rule and WCAG 2.1.

**Usage:**
```bash
./tests/test-html-lang-attribute.sh
```

**Expected Output (no HTML files present):**
```
✅ No HTML files found — html-has-lang check passes (nothing to fail).
```

**Expected Output (HTML files with lang attribute):**
```
✅ path/to/file.html
✅ All HTML files meet WCAG 2.1 html-has-lang requirement
```

## Running Tests

To run all accessibility tests:
```bash
cd /path/to/repository
./tests/test-student-folder-template-heading.sh
./tests/check-markdown-accessibility.sh
./tests/test-html-lang-attribute.sh
```

## WCAG 2.1 Compliance

These tests help ensure compliance with WCAG 2.1 accessibility requirements:
- **page-has-heading-one**: Pages should have a level-one heading. Important for screen reader navigation, document structure, and accessibility scanning tools.
- **html-has-lang**: The `<html>` element must have a `lang` attribute so assistive technologies can identify the language of the page.

## References

- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [Deque University: HTML Has Lang](https://dequeuniversity.com/rules/axe/4.11/html-has-lang)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

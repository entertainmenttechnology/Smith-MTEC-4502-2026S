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

### check-html-lang.sh
Checks all HTML files in the repository for a `lang` attribute on the `<html>` element.
This prevents regressions of the `html-has-lang` axe rule (WCAG 3.1.1 / Language of Page).

**Usage:**
```bash
./tests/check-html-lang.sh
```

**Expected Output (no HTML files present):**
```
✅ No HTML files found — nothing to check
```

**Expected Output (HTML files present and compliant):**
```
✅ path/to/file.html
Summary: 1/1 HTML files have a lang attribute on <html>
✅ All HTML files have a lang attribute on the <html> element
```

## Running Tests

To run all accessibility tests:
```bash
cd /path/to/repository
./tests/test-student-folder-template-heading.sh
./tests/check-markdown-accessibility.sh
./tests/check-html-lang.sh
```

## WCAG 2.1 Compliance

These tests help ensure compliance with WCAG 2.1 Level A requirements:

- **Heading structure** (`page-has-heading-one`): Pages should have a level-one heading for screen reader navigation and document structure.
- **Language of page** (`html-has-lang`, WCAG 3.1.1): HTML documents must have a `lang` attribute on the `<html>` element so assistive technologies can determine the language of the content.

## References

- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [Deque University: HTML Has Lang](https://dequeuniversity.com/rules/axe/4.11/html-has-lang)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [WCAG 3.1.1 Language of Page](https://www.w3.org/WAI/WCAG21/Understanding/language-of-page.html)

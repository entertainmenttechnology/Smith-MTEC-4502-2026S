---
lang: en
---

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

### check-lang-attribute.sh
Checks all markdown files in the repository for a `lang` attribute in YAML front matter, which is used by static site generators to set the `lang` attribute on the `<html>` element (WCAG 2.1 / axe rule: html-has-lang).

**Usage:**
```bash
./tests/check-lang-attribute.sh
```

**Expected Output:**
```
✅ All markdown files have a lang attribute
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
./tests/check-lang-attribute.sh
```

## WCAG 2.1 Compliance

These tests help ensure compliance with WCAG 2.1 accessibility requirements:
- **Level-one heading**: Pages should have a level-one heading for screen reader navigation and document structure.
- **Language declaration**: Pages must declare a language (`lang` attribute on `<html>`) so assistive technologies use the correct language and pronunciation.

This is important for:
- Screen reader navigation
- Document structure and semantics
- Accessibility scanning tools

## References

- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [Deque University: HTML Element Must Have a Lang Attribute](https://dequeuniversity.com/rules/axe/4.11/html-has-lang)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

---
lang: en
---

# Accessibility Tests

This directory contains tests to ensure WCAG 2.1 accessibility compliance for markdown files in the repository.

## Available Tests

### test-living-job-taxonomy-lang.sh
Tests that `resources/Living Job Taxonomy.md` has a `lang` attribute in its YAML front matter as required by WCAG 2.1 SC 3.1.1 (html-has-lang rule).

**Usage:**
```bash
./tests/test-living-job-taxonomy-lang.sh
```

**Expected Output:**
```
✅ 'resources/Living Job Taxonomy.md' has lang attribute: lang: en
```

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
./tests/test-living-job-taxonomy-lang.sh
./tests/test-student-folder-template-heading.sh
./tests/check-markdown-accessibility.sh
```

## WCAG 2.1 Compliance

These tests help ensure compliance with WCAG 2.1 requirements:
- **SC 3.1.1 Language of Page**: The `lang` attribute on the `<html>` element identifies the primary language of the page (html-has-lang rule).
- **Level A heading**: Pages should have a level-one heading for screen reader navigation and document structure.

This is important for:
- Screen reader navigation
- Document structure and semantics
- Accessibility scanning tools

## References

- [Deque University: html-has-lang](https://dequeuniversity.com/rules/axe/4.11/html-has-lang)
- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

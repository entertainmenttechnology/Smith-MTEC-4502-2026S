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
Checks all HTML files in the repository for a `lang` attribute on the `<html>` element. This prevents the `html-has-lang` axe violation (WCAG 2.1 Success Criterion 3.1.1 — Language of Page).

**Usage:**
```bash
./tests/check-html-lang.sh
```

**Expected Output (no HTML files present):**
```
✅ No HTML files found — no violations possible
```

**Expected Output (HTML files present and compliant):**
```
✅ ./path/to/file.html
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

These tests help ensure compliance with WCAG 2.1 accessibility requirements:

- **Level A — 1.3.1 (Info and Relationships)**: Pages should have a level-one heading for proper document structure.
- **Level A — 3.1.1 (Language of Page)**: Every HTML document must identify its primary language via the `lang` attribute on the `<html>` element.

These are important for:
- Screen reader navigation
- Document structure and semantics
- Accessibility scanning tools (e.g., axe-core)

## References

- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [Deque University: HTML Has Lang](https://dequeuniversity.com/rules/axe/4.11/html-has-lang)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

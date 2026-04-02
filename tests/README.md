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
Checks all HTML files in the repository for a `lang` attribute on the `<html>` element. This prevents the axe `html-has-lang` accessibility violation (WCAG 2.1 Success Criterion 3.1.1 – Language of Page).

**Usage:**
```bash
./tests/check-html-lang.sh
```

**Expected Output (no HTML files present):**
```
✅ No HTML files found — nothing to check.
Summary: 0/0 HTML files checked
```

**Expected Output (HTML files present and compliant):**
```
✅ path/to/file.html
Summary: 1/1 HTML files have lang attribute on <html>
✅ All HTML files have a lang attribute on <html>
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
- **Level-one headings** (document structure best practice): Pages should have a level-one heading for screen reader navigation, document structure, and accessibility scanning tools.
- **Language of Page** (Success Criterion 3.1.1): Every HTML document must declare its language via `lang` attribute on the `<html>` element so assistive technologies can apply the correct language rules.

## References

- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [Deque University: HTML Has Lang](https://dequeuniversity.com/rules/axe/4.11/html-has-lang)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [WCAG 2.1 SC 3.1.1 Language of Page](https://www.w3.org/WAI/WCAG21/Understanding/language-of-page)

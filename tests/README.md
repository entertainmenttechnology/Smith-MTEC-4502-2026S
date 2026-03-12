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

### test-student-information-lang.sh
Tests that `student-information.md` contains a `lang` front matter attribute as required by WCAG 2.1 SC 3.1.1 (html-has-lang rule).

**Usage:**
```bash
./tests/test-student-information-lang.sh
```

**Expected Output:**
```
✅ student-information.md has a lang front matter attribute: lang: en
```

### check-markdown-lang.sh
Checks all markdown files in the repository for a `lang` front matter attribute.

**Usage:**
```bash
./tests/check-markdown-lang.sh
```

## Running Tests

To run all accessibility tests:
```bash
cd /path/to/repository
./tests/test-student-folder-template-heading.sh
./tests/check-markdown-accessibility.sh
./tests/test-student-information-lang.sh
./tests/check-markdown-lang.sh
```

## WCAG 2.1 Compliance

These tests help ensure compliance with:
- WCAG 2.1 Level A requirement that pages should have a level-one heading.
- WCAG 2.1 SC 3.1.1 (Language of Page) requiring documents to specify their human language.

This is important for:
- Screen reader navigation
- Document structure and semantics
- Accessibility scanning tools

## References

- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [Deque University: HTML Has Lang](https://dequeuniversity.com/rules/axe/4.11/html-has-lang)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

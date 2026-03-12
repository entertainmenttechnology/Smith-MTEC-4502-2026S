# Accessibility Tests

This directory contains tests to ensure WCAG 2.1 accessibility compliance for markdown files in the repository.

## Available Tests

### test-html-lang-attribute.sh
Tests that `_config.yml` has a `lang` attribute and `resources/02_Resources.md` has YAML front matter with `lang: en` as required by WCAG 2.1 (html-has-lang rule).

**Usage:**
```bash
./tests/test-html-lang-attribute.sh
```

**Expected Output:**
```
✅ _config.yml has lang: en
✅ resources/02_Resources.md has lang: en
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
./tests/test-html-lang-attribute.sh
./tests/test-student-folder-template-heading.sh
./tests/check-markdown-accessibility.sh
```

## WCAG 2.1 Compliance

These tests help ensure compliance with:
- WCAG 2.1 Level A: pages must have a level-one heading (page-has-heading-one)
- WCAG 2.1 Level A: HTML documents must have a lang attribute (html-has-lang)

Both are important for:
- Screen reader navigation
- Document structure and semantics
- Accessibility scanning tools

## References

- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [Deque University: HTML Has Lang](https://dequeuniversity.com/rules/axe/4.11/html-has-lang)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

# Accessibility Tests

This directory contains tests to ensure WCAG 2.1 accessibility compliance for markdown files in the repository.

## Available Tests

### check-lang-attribute.sh
Tests that:
1. `_config.yml` has a site-level `lang:` setting for WCAG 2.1 html-has-lang compliance.
2. All HTML layout files (e.g., `_layouts/default.html`) include a `lang` attribute on the `<html>` element.
3. `resources/speculative_future_careers.md` has `lang:` declared in its front matter.

**Usage:**
```bash
./tests/check-lang-attribute.sh
```

**Expected Output:**
```
✅ _config.yml has lang: en
✅ _layouts/default.html
✅ resources/speculative_future_careers.md has lang: en in front matter
✅ All lang attribute checks passed
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
./tests/check-lang-attribute.sh
./tests/test-student-folder-template-heading.sh
./tests/check-markdown-accessibility.sh
```

## WCAG 2.1 Compliance

These tests help ensure compliance with WCAG 2.1 Level A requirement that pages should have a level-one heading. This is important for:
- Screen reader navigation
- Document structure and semantics
- Accessibility scanning tools

## References

- [Deque University: HTML Has Lang](https://dequeuniversity.com/rules/axe/4.11/html-has-lang?application=playwright)
- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

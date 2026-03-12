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

### check-link-in-text-block.sh
Checks all markdown files for inline links that use a bare URL as the link text while appearing within a sentence. Such links are only distinguishable from surrounding text by color, which violates WCAG 2.1 and the axe `link-in-text-block` rule.

**Usage:**
```bash
./tests/check-link-in-text-block.sh
```

**Expected Output:**
```
✅ All inline links use descriptive link text
```

## Running Tests

To run all accessibility tests:
```bash
cd /path/to/repository
./tests/test-student-folder-template-heading.sh
./tests/check-markdown-accessibility.sh
./tests/check-link-in-text-block.sh
```

## WCAG 2.1 Compliance

These tests help ensure compliance with WCAG 2.1 accessibility requirements:

- **page-has-heading-one**: Pages should have a level-one heading. Important for screen reader navigation, document structure, and semantics.
- **link-in-text-block**: Links that appear inline within a paragraph must be distinguishable from surrounding text without relying solely on color. Using descriptive link text (rather than bare URLs) helps meet this requirement.

## References

- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [Deque University: Link In Text Block](https://dequeuniversity.com/rules/axe/4.11/link-in-text-block)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

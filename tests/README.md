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

### test-link-in-text-block.sh
Checks all markdown files to ensure hyperlinks are not embedded inside italic (`*...*`) text blocks. When GitHub renders italic text, it applies a muted gray color (`#7b7c7d`). Links inside italic blocks have a contrast ratio of ~1.29:1 against this gray — well below the required 3:1 minimum — causing a WCAG 2.1 `link-in-text-block` violation.

**Usage:**
```bash
./tests/test-link-in-text-block.sh
```

**Expected Output:**
```
✅ No links found inside italic text blocks
```

## Running Tests

To run all accessibility tests:
```bash
cd /path/to/repository
./tests/test-student-folder-template-heading.sh
./tests/check-markdown-accessibility.sh
./tests/test-link-in-text-block.sh
```

## WCAG 2.1 Compliance

These tests help ensure compliance with the following WCAG 2.1 requirements:
- **Level A – page-has-heading-one**: Pages should have a level-one heading for screen reader navigation.
- **Level AA – link-in-text-block**: Links in text blocks must be distinguishable from surrounding text without relying on color alone (requires underline or ≥3:1 contrast ratio against surrounding text).

## References

- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [Deque University: Link in Text Block](https://dequeuniversity.com/rules/axe/4.11/link-in-text-block)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

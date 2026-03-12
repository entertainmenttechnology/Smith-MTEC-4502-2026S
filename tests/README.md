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
Tests that `student-information.md` has no plain (unstyled) inline links in paragraph text. This ensures compliance with the WCAG 2.1 `link-in-text-block` rule, which requires that links inside text blocks are distinguishable from surrounding text without relying on color alone.

**Usage:**
```bash
./tests/check-link-in-text-block.sh
```

**Expected Output:**
```
✅ student-information.md has no plain inline links in paragraph text
   (link-in-text-block accessibility rule is satisfied)
```

**How to fix violations:**
If a plain inline link is found in paragraph text, use one of the following approaches:
1. Wrap in bold: `**[link text](url)**`
2. Use HTML underline: `<u>[link text](url)</u>`
3. Move the link to a list item, table cell, or heading

## Running Tests

To run all accessibility tests:
```bash
cd /path/to/repository
./tests/test-student-folder-template-heading.sh
./tests/check-markdown-accessibility.sh
./tests/check-link-in-text-block.sh
```

## WCAG 2.1 Compliance

These tests help ensure compliance with WCAG 2.1 Level A and AA requirements:

- **page-has-heading-one**: Pages should have a level-one heading for screen reader navigation and document structure.
- **link-in-text-block**: Links inside text blocks must be distinguishable from surrounding text without relying on color alone (minimum 3:1 contrast ratio, or a non-color visual indicator such as underline or bold).

## References

- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [Deque University: Link In Text Block](https://dequeuniversity.com/rules/axe/4.11/link-in-text-block)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

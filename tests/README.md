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

### check-link-accessibility.sh
Checks all markdown files for accessible, descriptive link text. Prevents WCAG 2.4.4 (Link Purpose) and link-in-text-block violations (axe rule: link-in-text-block) by ensuring links do not use ambiguous anchor text such as "here" or "click here".

**Usage:**
```bash
./tests/check-link-accessibility.sh
```

**Expected Output:**
```
✅ All markdown files have accessible link text
```

## Running Tests

To run all accessibility tests:
```bash
cd /path/to/repository
./tests/test-student-folder-template-heading.sh
./tests/check-markdown-accessibility.sh
./tests/check-link-accessibility.sh
```

## WCAG 2.1 Compliance

These tests help ensure compliance with WCAG 2.1 requirements:
- **Level A** — Pages should have a level-one heading. This is important for screen reader navigation, document structure and semantics, and accessibility scanning tools.
- **Level AA** — Links must have descriptive text and be distinguishable from surrounding text without relying solely on color (link-in-text-block rule). This ensures links are usable for people with color vision deficiencies.

## References

- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [Deque University: Link In Text Block](https://dequeuniversity.com/rules/axe/4.11/link-in-text-block)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

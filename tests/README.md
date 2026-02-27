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

### test-heading-order.sh
Tests all markdown files in the repository for valid heading order. Ensures heading levels only increase by one at a time, in compliance with WCAG 2.1 and the axe `heading-order` rule.

**Usage:**
```bash
./tests/test-heading-order.sh
```

**Expected Output:**
```
✅ All markdown files have valid heading order
```

## Running Tests

To run all accessibility tests:
```bash
cd /path/to/repository
./tests/test-student-folder-template-heading.sh
./tests/check-markdown-accessibility.sh
./tests/test-heading-order.sh
```

## WCAG 2.1 Compliance

These tests help ensure compliance with WCAG 2.1 accessibility requirements. This is important for:
- Screen reader navigation
- Document structure and semantics
- Accessibility scanning tools

### page-has-heading-one

Level A requirement that pages should have a level-one heading. Tested by `check-markdown-accessibility.sh` and `test-student-folder-template-heading.sh`.

### heading-order

Heading levels should only increase by one at a time. Skipping heading levels (e.g. jumping from `h2` to `h4`) makes navigation difficult for screen reader users. Tested by `test-heading-order.sh`.

## References

### Axe Accessibility Rules

- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [Deque University: Heading Order](https://dequeuniversity.com/rules/axe/4.11/heading-order)

### WCAG Standards

- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

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

### check-heading-order.sh
Checks all markdown files in the repository for valid heading order (axe rule: heading-order). Headings should only increase by one level at a time to ensure WCAG 2.1 compliance.

**Usage:**
```bash
./tests/check-heading-order.sh
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
./tests/check-heading-order.sh
```

## WCAG 2.1 Compliance

These tests help ensure compliance with WCAG 2.1 accessibility requirements:
- **Level A**: Pages should have a level-one heading ([page-has-heading-one](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one))
- **Heading order**: Heading levels should only increase by one ([heading-order](https://dequeuniversity.com/rules/axe/4.11/heading-order))

This is important for:
- Screen reader navigation
- Document structure and semantics
- Accessibility scanning tools

## References

- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [Deque University: Heading Order](https://dequeuniversity.com/rules/axe/4.11/heading-order)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

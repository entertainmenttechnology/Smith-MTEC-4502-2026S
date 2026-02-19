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
Validates that heading levels in markdown files follow proper order (only increase by one level) and are not nested inside list items. This ensures compliance with WCAG 2.1 heading-order requirements.

**Usage:**
```bash
./tests/test-heading-order.sh
```

**Expected Output:**
```
✅ All markdown files have proper heading order
```

**What it checks:**
- Heading levels only increase by one at a time (e.g., H1→H2→H3, not H1→H3)
- Headings are not nested inside list items (e.g., `* ### Heading` is invalid)

## Running Tests

To run all accessibility tests:
```bash
cd /path/to/repository
./tests/test-student-folder-template-heading.sh
./tests/check-markdown-accessibility.sh
./tests/test-heading-order.sh
```

## WCAG 2.1 Compliance

These tests help ensure compliance with WCAG 2.1 requirements:
- **Level-one heading requirement (Level A)**: Pages should have a level-one heading for proper document structure
- **Heading order requirement (Level A)**: Heading levels should only increase by one to maintain logical structure
- **Proper semantic structure**: Headings should not be nested in list items to ensure screen reader compatibility

These requirements are important for:
- Screen reader navigation
- Document structure and semantics
- Accessibility scanning tools

## References

- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [Deque University: Heading Order](https://dequeuniversity.com/rules/axe/4.11/heading-order)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

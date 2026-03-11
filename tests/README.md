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
Validates that heading levels in markdown files follow proper hierarchy and only increase by one level at a time, as required by WCAG 2.1 (heading-order rule). This prevents accessibility violations where headings skip levels (e.g., H1 to H3).

**Usage:**
```bash
./tests/check-heading-order.sh
```

**What it checks:**
- First heading must be H1 (#)
- Headings should not skip levels (e.g., don't go from H2 to H4)
- Headings can decrease by any amount (e.g., H4 to H2 is OK)

**Expected Output:**
```
✅ All markdown files have proper heading order
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

These tests help ensure compliance with WCAG 2.1 Level A requirements:

### Heading Requirements
- **Page Has Heading One**: All pages should have a level-one heading for proper document structure
- **Heading Order**: Heading levels should only increase by one to maintain logical hierarchy

This is important for:
- Screen reader navigation
- Document structure and semantics
- Accessibility scanning tools
- Cognitive accessibility

## References

- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [Deque University: Heading Order](https://dequeuniversity.com/rules/axe/4.11/heading-order)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

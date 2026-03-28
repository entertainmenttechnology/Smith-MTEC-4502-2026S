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
Checks all markdown files in the repository for proper heading order as required by WCAG 2.1 (heading-order rule). Ensures heading levels only increase by one at a time.

**Usage:**
```bash
./tests/check-heading-order.sh
```

**Expected Output:**
```
✅ All markdown files have proper heading order
```

**What it checks:**
- First heading in each file must be level 1 (H1)
- Heading levels can only increase by one (e.g., H1→H2→H3, not H1→H3)
- Heading levels can decrease by any amount (e.g., H3→H1 is valid)

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

### Level-One Heading (page-has-heading-one)
Pages should have a level-one heading for proper document structure and screen reader navigation.

### Heading Order (heading-order)
Heading levels should only increase by one at a time. This ensures proper document outline and helps screen reader users understand the content hierarchy.

These requirements are important for:
- Screen reader navigation
- Document structure and semantics
- Accessibility scanning tools
- SEO and content organization

## References

- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [Deque University: Heading Order](https://dequeuniversity.com/rules/axe/4.11/heading-order)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

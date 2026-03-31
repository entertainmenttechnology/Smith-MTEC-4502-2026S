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
Checks all markdown files for proper heading order to ensure WCAG 2.1 compliance (heading-order rule). Validates that:
- Documents start with an H1 heading
- Heading levels don't skip (e.g., H1 → H3 without H2 is invalid)
- All heading levels from H1 to the highest used level are present

**Usage:**
```bash
./tests/check-heading-order.sh
```

**Expected Output:**
```
✅ ./assignments/05-Assignment_Evaluating_Portfolio_Platforms.md
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

- **page-has-heading-one**: Pages should have a level-one heading for screen reader navigation and document structure
- **heading-order**: Heading levels should only increase by one to maintain proper document hierarchy

These requirements are important for:
- Screen reader navigation
- Document structure and semantics
- Accessibility scanning tools
- SEO and content organization

## References

- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [Deque University: Heading Order](https://dequeuniversity.com/rules/axe/4.11/heading-order)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

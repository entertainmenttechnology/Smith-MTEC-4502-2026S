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

### test-heading-order-01a.sh
Tests that `assignments/01a_Reflective_essay_draft_speculation_phase.md` has proper heading order (heading levels increase by one) as required by WCAG 2.1 (heading-order rule).

**Usage:**
```bash
./tests/test-heading-order-01a.sh
```

**Expected Output:**
```
✅ Heading order test PASSED
```

## Running Tests

To run all accessibility tests:
```bash
cd /path/to/repository
./tests/test-student-folder-template-heading.sh
./tests/check-markdown-accessibility.sh
./tests/test-heading-order-01a.sh
```

## WCAG 2.1 Compliance

These tests help ensure compliance with WCAG 2.1 Level A requirements:

1. **Page Has Heading One** (page-has-heading-one): Pages should have a level-one heading for proper document structure
2. **Heading Order** (heading-order): Headings should increase by only one level at a time (H1→H2→H3, not H1→H3)

These requirements are important for:
- Screen reader navigation
- Document structure and semantics
- Accessibility scanning tools
- Keyboard navigation

## References

- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [Deque University: Heading Order](https://dequeuniversity.com/rules/axe/4.11/heading-order)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

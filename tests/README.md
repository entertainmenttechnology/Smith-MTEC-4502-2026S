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
Validates that heading levels in markdown files follow proper semantic order according to WCAG 2.1 guidelines.
- First heading must be level 1 (h1)
- Heading levels should only increase by one (e.g., h1 → h2 → h3 is valid, but h1 → h3 is not)
- Heading levels can decrease by any amount (e.g., h3 → h1 is valid)

**Usage:**
```bash
./tests/check-heading-order.sh
```

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

These tests help ensure compliance with WCAG 2.1 accessibility requirements:

**Level-one heading (Level A):** Pages should have a level-one heading. This is important for:
- Screen reader navigation
- Document structure and semantics
- Accessibility scanning tools

**Heading order (Level A):** Heading levels should only increase by one. This is important for:
- Proper document hierarchy
- Screen reader navigation
- Semantic structure and understanding
- Meeting axe-core heading-order rule requirements

## References

- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [Deque University: Heading Order](https://dequeuniversity.com/rules/axe/4.11/heading-order)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

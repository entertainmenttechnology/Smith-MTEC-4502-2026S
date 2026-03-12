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

### check-landmark-one-main.sh
Tests that `assignments/01c2-mtec_4502_assignment_1c_part2_future_modeling_and_adaptive_planning.md`
complies with the WCAG 2.1 `landmark-one-main` rule. Specifically, it verifies:
- The file exists
- The file has a level-one heading
- The file does not contain inline `<main>` HTML elements that would create duplicate landmarks
- The file does not contain structural HTML elements (`<body>`, `<html>`, etc.) that could break page layout

**Usage:**
```bash
./tests/check-landmark-one-main.sh
```

**Expected Output:**
```
✅ File exists: assignments/01c2-mtec_4502_assignment_1c_part2_future_modeling_and_adaptive_planning.md
✅ File has a level-one heading
✅ File does not contain conflicting <main> HTML elements
✅ File does not contain structural HTML elements that could break page layout
✅ assignments/01c2-mtec_4502_assignment_1c_part2_future_modeling_and_adaptive_planning.md passes landmark-one-main accessibility checks
```

## Running Tests

To run all accessibility tests:
```bash
cd /path/to/repository
./tests/test-student-folder-template-heading.sh
./tests/check-markdown-accessibility.sh
./tests/check-landmark-one-main.sh
```

## WCAG 2.1 Compliance

These tests help ensure compliance with WCAG 2.1 Level A requirements:
- **page-has-heading-one**: Pages should have a level-one heading. This is important for screen reader navigation, document structure, and accessibility scanning tools.
- **landmark-one-main**: Pages should have exactly one main landmark. This ensures proper page structure and assists screen readers in identifying the primary content area.

## References

- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [Deque University: Landmark One Main](https://dequeuniversity.com/rules/axe/4.11/landmark-one-main)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

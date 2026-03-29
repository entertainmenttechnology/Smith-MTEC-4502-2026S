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

### test-assignment-link-accessibility.sh
Tests that links in `assignments/01c2-mtec_4502_assignment_1c_part2_future_modeling_and_adaptive_planning.md` use descriptive accessible text. This prevents regression of the axe `link-in-text-block` violation (WCAG 2.1 SC 2.4.4 Link Purpose).

**Usage:**
```bash
./tests/test-assignment-link-accessibility.sh
```

**Expected Output:**
```
✅ All link accessibility checks passed for:
   01c2-mtec_4502_assignment_1c_part2_future_modeling_and_adaptive_planning.md
```

## Running Tests

To run all accessibility tests:
```bash
cd /path/to/repository
./tests/test-student-folder-template-heading.sh
./tests/check-markdown-accessibility.sh
./tests/test-assignment-link-accessibility.sh
```

## WCAG 2.1 Compliance

These tests help ensure compliance with WCAG 2.1 accessibility requirements:

- **Level A – page-has-heading-one**: Pages should have a level-one heading for screen reader navigation and document structure.
- **Level AA – link-in-text-block**: Links must be distinguishable from surrounding text without relying solely on color. Links should use descriptive text that conveys the link's purpose.

## References

- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [Deque University: Link in Text Block](https://dequeuniversity.com/rules/axe/4.11/link-in-text-block)
- [WCAG 2.1 SC 2.4.4: Link Purpose (In Context)](https://www.w3.org/WAI/WCAG21/Understanding/link-purpose-in-context)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

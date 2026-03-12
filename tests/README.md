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

### test-assignment-01c2-landmark.sh
Verifies that `assignments/01c2-mtec_4502_assignment_1c_part2_future_modeling_and_adaptive_planning.md` satisfies the axe `region` landmark accessibility rule. This test ensures the first rendered content in the file is a level-one heading (HTML comments before the heading are allowed and not considered rendered content).

This test was added to prevent regression of the accessibility violation reported for the `region` rule (all page content should be contained by landmarks).

**Usage:**
```bash
./tests/test-assignment-01c2-landmark.sh
```

**Expected Output:**
```
✅ assignments/01c2-mtec_4502_assignment_1c_part2_future_modeling_and_adaptive_planning.md passes the 'region' landmark accessibility check
   First rendered content: # MTEC 4502 – Career and Portfolio Seminar
```

### test-landmark-accessibility.sh
Checks all markdown files in the repository for landmark/region accessibility compliance. Verifies that the first rendered content line (excluding HTML comments) in each file is a level-one heading.

**Usage:**
```bash
./tests/test-landmark-accessibility.sh
```

## Running Tests

To run all accessibility tests:
```bash
cd /path/to/repository
./tests/test-student-folder-template-heading.sh
./tests/check-markdown-accessibility.sh
./tests/test-assignment-01c2-landmark.sh
./tests/test-landmark-accessibility.sh
```

## WCAG 2.1 Compliance

These tests help ensure compliance with WCAG 2.1 requirements:
- **page-has-heading-one**: Pages should have a level-one heading. This is important for screen reader navigation, document structure and semantics.
- **region**: All page content should be contained within landmark regions. Having a level-one heading as the first rendered content ensures content is properly anchored within the page's landmark structure.

## References

- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [Deque University: Region (All page content contained by landmarks)](https://dequeuniversity.com/rules/axe/4.11/region)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

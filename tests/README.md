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

### test-01c-visualization-landmark.sh
Tests that `assignments/01c MTEC 4502 Assignment week 3  - Integrating Visualization.md` satisfies the `landmark-one-main` axe accessibility rule. Verifies the file has a level-one heading, that it appears near the top of the document, and that the document has a proper heading hierarchy.

**Usage:**
```bash
./tests/test-01c-visualization-landmark.sh
```

**Expected Output:**
```
✅ File exists
✅ Has level-one heading (H1): # **MTEC 4502 \- Career and Portfolio Seminar.  Assignment Week 3\.**
✅ Level-one heading appears near the top of the document
✅ Has 7 H2 section heading(s) for content structure
✅ assignments/01c MTEC 4502 Assignment week 3  - Integrating Visualization.md passes landmark-one-main accessibility check
```

## Running Tests

To run all accessibility tests:
```bash
cd /path/to/repository
./tests/test-student-folder-template-heading.sh
./tests/check-markdown-accessibility.sh
./tests/test-01c-visualization-landmark.sh
```

## WCAG 2.1 Compliance

These tests help ensure compliance with WCAG 2.1 Level A requirement that pages should have a level-one heading. This is important for:
- Screen reader navigation
- Document structure and semantics
- Accessibility scanning tools

## References

- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

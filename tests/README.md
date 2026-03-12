# Accessibility Tests

This directory contains tests to ensure WCAG 2.1 accessibility compliance for markdown files in the repository.

## Available Tests

### test-portfolio-planning-landmark.sh
Tests that `resources/09_portfolio_planning.md` contains a `<main>` HTML landmark as required by WCAG 2.1 (landmark-one-main rule).

**Usage:**
```bash
./tests/test-portfolio-planning-landmark.sh
```

**Expected Output:**
```
✅ resources/09_portfolio_planning.md has a <main> landmark
```

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

## Running Tests

To run all accessibility tests:
```bash
cd /path/to/repository
./tests/test-portfolio-planning-landmark.sh
./tests/test-student-folder-template-heading.sh
./tests/check-markdown-accessibility.sh
```

## WCAG 2.1 Compliance

These tests help ensure compliance with WCAG 2.1 accessibility requirements:
- Pages should have a level-one heading — important for screen reader navigation and document structure.
- Pages should have a main landmark — enables users to skip to primary content.

## References

- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [Deque University: Landmark One Main](https://dequeuniversity.com/rules/axe/4.11/landmark-one-main)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

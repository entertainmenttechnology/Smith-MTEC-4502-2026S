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

### test-01b-assignment-lang.sh
Tests that `assignments/01b MTEC 4502 Strategic Framework Assignment.md` has a level-one heading, satisfying the `page-has-heading-one` WCAG 2.1 accessibility requirement for the file flagged with an `html-has-lang` accessibility violation.

**Usage:**
```bash
./tests/test-01b-assignment-lang.sh
```

**Expected Output:**
```
✅ Has level-one heading (page-has-heading-one): # MTEC 4502 Strategic Framework Assignment
✅ All accessibility checks passed for assignments/01b MTEC 4502 Strategic Framework Assignment.md
```

## Running Tests

To run all accessibility tests:
```bash
cd /path/to/repository
./tests/test-student-folder-template-heading.sh
./tests/check-markdown-accessibility.sh
./tests/test-01b-assignment-lang.sh
```

## WCAG 2.1 Compliance

These tests help ensure compliance with WCAG 2.1 Level A requirement that pages should have a level-one heading. This is important for:
- Screen reader navigation
- Document structure and semantics
- Accessibility scanning tools

## References

- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

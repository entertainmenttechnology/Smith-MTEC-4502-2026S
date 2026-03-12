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

### test-assignment-05-accessibility.sh
Tests that `assignments/05-Assignment_Evaluating_Portfolio_Platforms.md` meets accessibility requirements, including a level-one heading, standard heading syntax, and valid heading hierarchy (WCAG 2.1 region/structure rules).

**Usage:**
```bash
./tests/test-assignment-05-accessibility.sh
```

**Expected Output:**
```
✅ assignments/05-Assignment_Evaluating_Portfolio_Platforms.md passes all accessibility checks
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
./tests/test-student-folder-template-heading.sh
./tests/test-assignment-05-accessibility.sh
./tests/check-markdown-accessibility.sh
```

## WCAG 2.1 Compliance

These tests help ensure compliance with WCAG 2.1 Level A requirement that pages should have a level-one heading. This is important for:
- Screen reader navigation
- Document structure and semantics
- Accessibility scanning tools

## References

- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [Deque University: Region (All page content should be contained by landmarks)](https://dequeuniversity.com/rules/axe/4.11/region?application=playwright)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

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

### check-region-landmark-structure.sh
Checks all markdown files in the repository for landmark-compliant structure, addressing the axe `region` rule. Specifically, it verifies that the first non-empty, non-comment line in each file is a heading, ensuring no content appears outside landmark regions.

This test prevents regression of the WCAG 2.1 / axe `region` violation:
> All page content must be contained by landmarks

**Usage:**
```bash
./tests/check-region-landmark-structure.sh
```

**Expected Output (for compliant files):**
```
✅ ./assignments/01a-d Scaffolded Assignment_ Reflective and analytical essay.md
```

## Running Tests

To run all accessibility tests:
```bash
cd /path/to/repository
./tests/test-student-folder-template-heading.sh
./tests/check-markdown-accessibility.sh
./tests/check-region-landmark-structure.sh
```

## WCAG 2.1 Compliance

These tests help ensure compliance with WCAG 2.1 accessibility requirements:

- **page-has-heading-one**: Pages should have a level-one heading (H1)
- **region**: All page content must be contained by landmarks — content before the first heading is not within any landmark section

## References

- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [Deque University: Region (All page content must be contained by landmarks)](https://dequeuniversity.com/rules/axe/4.11/region)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

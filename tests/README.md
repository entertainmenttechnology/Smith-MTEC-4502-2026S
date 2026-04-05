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

### check-markdown-region-landmarks.sh
Checks all markdown files to ensure all content is organized within heading-based regions. This corresponds to the axe `region` rule which requires all page content to be contained by landmark regions (WCAG 2.1).

Specifically, this test verifies:
1. Each file has at least one H1 heading (serving as the main content landmark anchor)
2. No text content appears before the first heading (which would render outside landmark regions)

**Usage:**
```bash
./tests/check-markdown-region-landmarks.sh
```

**Expected Output (for passing files):**
```
✅ ./assignments/01c MTEC 4502 Assignment week 3  - Integrating Visualization.md
```

## Running Tests

To run all accessibility tests:
```bash
cd /path/to/repository
./tests/test-student-folder-template-heading.sh
./tests/check-markdown-accessibility.sh
./tests/check-markdown-region-landmarks.sh
```

## WCAG 2.1 Compliance

These tests help ensure compliance with WCAG 2.1 requirements:

- **Page Has Heading One** (`page-has-heading-one`): Pages should have a level-one heading for screen reader navigation and document structure.
- **Region Rule** (`region`): All page content should be contained by landmark regions. This ensures assistive technologies can navigate page regions correctly.

## References

- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [Deque University: Region Rule](https://dequeuniversity.com/rules/axe/4.11/region)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

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

### test-landmark-regions.sh
Tests that all markdown files have a level-one heading as their first non-empty, non-comment line. This validates compliance with the axe `region` rule: *"All page content should be contained by landmarks"*. When markdown is rendered to HTML (e.g., on GitHub), content within a proper H1 heading structure is contained by the page's main landmark region.

**Usage:**
```bash
./tests/test-landmark-regions.sh
```

**Expected Output:**
```
✅ All markdown files comply with the axe 'region' rule
```

## Running Tests

To run all accessibility tests:
```bash
cd /path/to/repository
./tests/test-student-folder-template-heading.sh
./tests/check-markdown-accessibility.sh
./tests/test-landmark-regions.sh
```

## WCAG 2.1 Compliance

These tests help ensure compliance with the following WCAG 2.1 requirements:

- **Level A – Page Has Heading One**: Pages should have a level-one heading for screen reader navigation and document structure.
- **Region rule (axe)**: All page content should be contained by landmarks. A level-one heading as the first content ensures that, when rendered to HTML, all content is within the page's main landmark region and not orphaned outside any landmark.

## References

- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [Deque University: Region – All page content should be contained by landmarks](https://dequeuniversity.com/rules/axe/4.11/region?application=playwright)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

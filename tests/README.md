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

### test-living-job-taxonomy-main-landmark.sh
Tests that `resources/Living Job Taxonomy.md` contains a `<main>` HTML landmark element, as required by the `landmark-one-main` axe rule.

**Usage:**
```bash
./tests/test-living-job-taxonomy-main-landmark.sh
```

**Expected Output:**
```
✅ 'resources/Living Job Taxonomy.md' has a main landmark (<main> element)
```

### check-main-landmark.sh
Checks all markdown files in the repository for `<main>` HTML landmark elements.

**Usage:**
```bash
./tests/check-main-landmark.sh
```

## Running Tests

To run all accessibility tests:
```bash
cd /path/to/repository
./tests/test-student-folder-template-heading.sh
./tests/check-markdown-accessibility.sh
./tests/test-living-job-taxonomy-main-landmark.sh
./tests/check-main-landmark.sh
```

## WCAG 2.1 Compliance

These tests help ensure compliance with WCAG 2.1 accessibility requirements. This is important for:
- Screen reader navigation
- Document structure and semantics
- Accessibility scanning tools

### Level-one headings (`page-has-heading-one`)
Pages should have a level-one heading (H1) to provide document structure.

### Main landmarks (`landmark-one-main`)
Pages should have exactly one `<main>` landmark element to identify the primary content region.

## References

- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [Deque University: Landmark One Main](https://dequeuniversity.com/rules/axe/4.11/landmark-one-main)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

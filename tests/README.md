# Accessibility Tests

This directory contains tests to ensure WCAG 2.1 accessibility compliance for markdown files in the repository.

## Available Tests

### test-living-job-taxonomy-accessibility.sh
Tests `resources/Living Job Taxonomy.md` for WCAG 2.1 compliance and the axe
`region` rule (all page content should be contained by landmarks).

Checks performed:
- File exists
- Has a level-one heading (axe: `page-has-heading-one`)
- The first heading in the file is an H1 (content begins under a top-level landmark)
- No heading level is skipped (axe: `heading-order`)
- File is not empty

**Usage:**
```bash
./tests/test-living-job-taxonomy-accessibility.sh
```

**Expected Output:**
```
✅ 'resources/Living Job Taxonomy.md' passes all accessibility checks
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
./tests/test-living-job-taxonomy-accessibility.sh
./tests/test-student-folder-template-heading.sh
./tests/check-markdown-accessibility.sh
```

## WCAG 2.1 Compliance

These tests help ensure compliance with WCAG 2.1 Level A/AA requirements. This is important for:
- Screen reader navigation
- Document structure and semantics
- Accessibility scanning tools

Rules enforced:
| axe rule | WCAG criterion | Description |
|---|---|---|
| `page-has-heading-one` | 1.3.1 Info and Relationships | Every page must have an H1 heading |
| `heading-order` | 1.3.1 Info and Relationships | Heading levels must not be skipped |
| `region` | 1.3.1 Info and Relationships | All page content must be contained by landmark regions |

## References

- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [Deque University: Region (Landmark)](https://dequeuniversity.com/rules/axe/4.11/region)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

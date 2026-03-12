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

### test-living-job-taxonomy-color-contrast.sh
Tests that `resources/Living Job Taxonomy.md` contains no Markdown blockquote lines that would render with insufficient color contrast (WCAG 2.1 AA color-contrast rule). GitHub renders blockquote `<p>` elements with foreground color `#7b7c7d` on background `#f6f8fa`, which produces a contrast ratio of ~3.92:1 — below the required 4.5:1.

**Usage:**
```bash
./tests/test-living-job-taxonomy-color-contrast.sh
```

**Expected Output:**
```
✅ No blockquotes found — 'resources/Living Job Taxonomy.md' meets color-contrast requirements.
```

## Running Tests

To run all accessibility tests:
```bash
cd /path/to/repository
./tests/test-student-folder-template-heading.sh
./tests/check-markdown-accessibility.sh
./tests/test-living-job-taxonomy-color-contrast.sh
```

## WCAG 2.1 Compliance

These tests help ensure compliance with WCAG 2.1 Level A requirement that pages should have a level-one heading. This is important for:
- Screen reader navigation
- Document structure and semantics
- Accessibility scanning tools

## References

- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

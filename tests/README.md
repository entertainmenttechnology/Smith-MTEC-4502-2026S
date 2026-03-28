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

### check-color-contrast.sh
Checks markdown files for potential color contrast accessibility issues that could cause violations of WCAG 2.1 AA minimum contrast ratio thresholds. Specifically checks for:

- Inline HTML `style="color: ..."` attributes with known low-contrast colors (hard failure)
- `<font color="...">` tags with known low-contrast colors (hard failure)
- Bold-inside-heading patterns (e.g., `## **text**`) that can cause muted text rendering on GitHub (regression failure for previously fixed files; warning for others)

**Usage:**
```bash
./tests/check-color-contrast.sh
```

**Expected Output:**
```
✅ No color contrast violations found in markdown files
```

## Running Tests

To run all accessibility tests:
```bash
cd /path/to/repository
./tests/test-student-folder-template-heading.sh
./tests/check-markdown-accessibility.sh
./tests/check-color-contrast.sh
```

## WCAG 2.1 Compliance

These tests help ensure compliance with WCAG 2.1 Level AA requirements:

- Pages should have a level-one heading (Level A)
- Text elements must meet minimum color contrast ratio thresholds:
  - 4.5:1 for normal text (< 18pt or < 14pt bold)
  - 3:1 for large text (≥ 18pt or ≥ 14pt bold)

## References

- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [Deque University: Color Contrast](https://dequeuniversity.com/rules/axe/4.11/color-contrast)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

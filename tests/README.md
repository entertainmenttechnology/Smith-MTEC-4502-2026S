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

### test-readme-color-contrast.sh
Checks all markdown files for inline HTML style attributes that define known low-contrast color combinations. This prevents regression of the WCAG 2.1 AA color contrast violation (axe rule: color-contrast) where a `<p>` element rendered with foreground color #7b7c7d on background color #f6f8fa produced an insufficient contrast ratio of 3.92:1 (required: 4.5:1 for normal text at 14px).

**Usage:**
```bash
./tests/test-readme-color-contrast.sh
```

**Expected Output:**
```
✅ No inline HTML with known low-contrast color combinations found
```

## Running Tests

To run all accessibility tests:
```bash
cd /path/to/repository
./tests/test-student-folder-template-heading.sh
./tests/check-markdown-accessibility.sh
./tests/test-readme-color-contrast.sh
```

## WCAG 2.1 Compliance

These tests help ensure compliance with:
- **WCAG 2.1 Level A**: Pages should have a level-one heading (page-has-heading-one)
- **WCAG 2.1 Level AA**: Text must meet minimum color contrast ratio thresholds (color-contrast)
  - Normal text (< 18pt or < 14pt bold): minimum contrast ratio of 4.5:1
  - Large text (≥ 18pt or ≥ 14pt bold): minimum contrast ratio of 3:1

These checks are important for:
- Screen reader navigation
- Document structure and semantics
- Visual accessibility for users with low vision
- Accessibility scanning tools

## References

- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [Deque University: Color Contrast](https://dequeuniversity.com/rules/axe/4.11/color-contrast)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [WebAIM Contrast Checker](https://webaim.org/resources/contrastchecker/)

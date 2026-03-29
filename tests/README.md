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

### test-readme-link-accessibility.sh
Tests that `README.md` contains no links with empty (non-discernible) text, as required by WCAG 2.1 (link-name rule / SC 2.4.4).

**Usage:**
```bash
./tests/test-readme-link-accessibility.sh
```

**Expected Output:**
```
✅ README.md: all links have discernible text
```

## Running Tests

To run all accessibility tests:
```bash
cd /path/to/repository
./tests/test-student-folder-template-heading.sh
./tests/check-markdown-accessibility.sh
./tests/test-readme-link-accessibility.sh
```

## WCAG 2.1 Compliance

These tests help ensure compliance with WCAG 2.1 accessibility requirements:

- **Level A – Page Has Heading One** (`page-has-heading-one`): Pages should have a level-one heading. This is important for:
  - Screen reader navigation
  - Document structure and semantics
  - Accessibility scanning tools

- **Level A – Link Name** (`link-name`, WCAG 2.1 Level A Success Criterion 2.4.4): All links must have discernible text. This is important for:
  - Screen reader users who rely on link text to understand destination
  - Keyboard-only navigation
  - Compliance with axe accessibility rules

## References

- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [Deque University: Link Name](https://dequeuniversity.com/rules/axe/4.11/link-name)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

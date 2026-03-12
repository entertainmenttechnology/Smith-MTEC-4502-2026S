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
Tests that links in `README.md` are distinguishable without relying on color alone, per WCAG 2.1 SC 1.4.1 (Use of Color) and the axe `link-in-text-block` rule.

Specifically checks:
1. No links use bare URLs as link text.
2. Inline paragraph links (not in headings or lists) use bold or italic emphasis.

**Usage:**
```bash
./tests/test-readme-link-accessibility.sh
```

**Expected Output:**
```
✅ All links use descriptive text (not bare URLs)
✅ All inline paragraph links use bold or italic emphasis
✅ README.md passes link accessibility checks (WCAG 2.1 SC 1.4.1)
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

These tests help ensure compliance with WCAG 2.1 Level A requirement that pages should have a level-one heading. This is important for:
- Screen reader navigation
- Document structure and semantics
- Accessibility scanning tools

## References

- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

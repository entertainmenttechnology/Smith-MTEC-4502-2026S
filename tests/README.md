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

### check-link-text.sh
Checks all markdown files in the repository to ensure every link has discernible text. This addresses the WCAG 2.1 / axe `link-name` rule which requires all links to have an accessible name.

**Usage:**
```bash
./tests/check-link-text.sh
```

**Expected Output:**
```
✅ ./resources/02_Resources.md
✅ All markdown links have discernible text
```

## Running Tests

To run all accessibility tests:
```bash
cd /path/to/repository
./tests/test-student-folder-template-heading.sh
./tests/check-markdown-accessibility.sh
./tests/check-link-text.sh
```

## WCAG 2.1 Compliance

These tests help ensure compliance with WCAG 2.1 requirements, which is important for screen reader navigation, document structure and semantics, and accessibility scanning tools:

- **Level A: page-has-heading-one** — pages should have a level-one heading, important for screen reader navigation and document structure.
- **Level A: link-name** — all links must have discernible text, so screen readers can announce the purpose of each link.

## References

- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [Deque University: Link Name](https://dequeuniversity.com/rules/axe/4.11/link-name)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

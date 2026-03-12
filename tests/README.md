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

### test-link-accessibility.sh
Checks all markdown files in the repository for link accessibility issues, specifically ensuring links in text blocks are distinguishable without relying on color alone. This addresses the WCAG 2.1 / axe `link-in-text-block` rule.

The test flags non-descriptive link text such as "here", "click here", "read more", or "this link" — text that provides no meaning without relying on surrounding context or color to identify it as a link.

**Usage:**
```bash
./tests/test-link-accessibility.sh
```

**Expected Output:**
```
✅ All markdown files pass link accessibility checks
```

## Running Tests

To run all accessibility tests:
```bash
cd /path/to/repository
./tests/test-student-folder-template-heading.sh
./tests/check-markdown-accessibility.sh
./tests/test-link-accessibility.sh
```

## WCAG 2.1 Compliance

These tests help ensure compliance with the following WCAG 2.1 requirements:

- **Level A – Page Has Heading One:** Pages should have a level-one heading for screen reader navigation and document structure.
- **Level AA – Links in Text Blocks:** Links within body text must be distinguishable from surrounding text without relying on color alone. Links should either have sufficient color contrast (minimum 3:1 ratio against surrounding text) or use a non-color visual cue such as underline. Using descriptive link text also helps users understand the link's purpose without relying on visual styling.

## References

- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [Deque University: Links Must Be Distinguishable Without Color](https://dequeuniversity.com/rules/axe/4.11/link-in-text-block)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

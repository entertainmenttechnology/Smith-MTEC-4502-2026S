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

### check-link-names.sh
Checks all markdown files in the repository for links without discernible text.
This addresses the WCAG 2.1 `link-name` axe rule, ensuring every link has visible text, `aria-label`, or `aria-labelledby` so screen readers can identify link destinations.

**Usage:**
```bash
./tests/check-link-names.sh
```

**Detects:**
- Markdown links with empty text: `[](url)`
- HTML `<a>` tags with no text content: `<a href="..."></a>`
- Self-closing `<a>` tags without an `aria-label`: `<a href="..."/>`

**Reference:** [Deque University: Link Name](https://dequeuniversity.com/rules/axe/4.11/link-name)

## Running Tests

To run all accessibility tests:
```bash
cd /path/to/repository
./tests/test-student-folder-template-heading.sh
./tests/check-markdown-accessibility.sh
./tests/check-link-names.sh
```

## WCAG 2.1 Compliance

These tests help ensure compliance with WCAG 2.1 Level A requirement that pages should have a level-one heading. This is important for:
- Screen reader navigation
- Document structure and semantics
- Accessibility scanning tools

## References

- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

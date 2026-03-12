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

### check-link-accessibility.sh
Checks all markdown files for link accessibility issues per the WCAG 2.1 `link-in-text-block` rule. Ensures links have descriptive, non-vague text so they are distinguishable from surrounding content without relying on color alone.

**Usage:**
```bash
./tests/check-link-accessibility.sh
```

**What it checks:**
- Links do not have empty text `[](url)`
- Links do not use non-descriptive text such as "here", "click here", "link", "more", etc.

**Expected Output:**
```
✅ All markdown links have accessible text
```

**Reference:** [Deque University: Link In Text Block](https://dequeuniversity.com/rules/axe/4.11/link-in-text-block)

## Running Tests

To run all accessibility tests:
```bash
cd /path/to/repository
./tests/test-student-folder-template-heading.sh
./tests/check-markdown-accessibility.sh
./tests/check-link-accessibility.sh
```

## WCAG 2.1 Compliance

These tests help ensure compliance with WCAG 2.1 accessibility requirements:

- **Page Has Heading One** (Level A): Pages should have a level-one heading for screen reader navigation and document structure.
- **Link In Text Block** (Level AA): Links within blocks of text must be distinguishable from surrounding content without relying on color alone. Links should have descriptive text.

## References

- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [Deque University: Link In Text Block](https://dequeuniversity.com/rules/axe/4.11/link-in-text-block)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

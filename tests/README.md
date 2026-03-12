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

### test-05-assignment-landmark-main.sh
Specifically tests `assignments/05-Assignment_Evaluating_Portfolio_Platforms.md` for
`landmark-one-main` accessibility compliance:
- Exactly one H1 heading (identifies the document's primary content section)
- No inline `<main>` HTML elements (which would conflict with the rendered page template)

**Usage:**
```bash
./tests/test-05-assignment-landmark-main.sh
```

**Expected Output:**
```
✅ Exactly one H1 heading found (main landmark): #  Assignment: Exploring and Evaluating Portfolio Platforms  
✅ No conflicting <main> HTML elements found
✅ assignments/05-Assignment_Evaluating_Portfolio_Platforms.md meets landmark-main accessibility requirements
```

## Running Tests

To run all accessibility tests:
```bash
cd /path/to/repository
./tests/test-student-folder-template-heading.sh
./tests/check-markdown-accessibility.sh
./tests/test-05-assignment-landmark-main.sh
```

## WCAG 2.1 Compliance

These tests help ensure compliance with WCAG 2.1 Level A requirement that pages should have a level-one heading. This is important for:
- Screen reader navigation
- Document structure and semantics
- Accessibility scanning tools

The landmark-main tests additionally ensure compliance with the `landmark-one-main` axe rule,
which requires pages to have exactly one `<main>` landmark for proper screen reader navigation.

## References

- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [Deque University: Landmark One Main](https://dequeuniversity.com/rules/axe/4.11/landmark-one-main)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

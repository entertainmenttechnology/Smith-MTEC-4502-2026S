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

### check-landmark-one-main.sh
Checks all markdown files to ensure they do not contain inline HTML `<main>` elements. Adding a `<main>` element inside a markdown file would create duplicate main landmarks on GitHub-rendered pages (which already provide one `<main>` from the page template), violating the WCAG 2.1 `landmark-one-main` accessibility rule.

**Usage:**
```bash
./tests/check-landmark-one-main.sh
```

**Expected Output:**
```
✅ All markdown files comply with landmark-one-main rule
   (No inline <main> elements found outside code blocks;
    GitHub provides exactly one <main> landmark per page from its page template.)
```

## Running Tests

To run all accessibility tests:
```bash
cd /path/to/repository
./tests/test-student-folder-template-heading.sh
./tests/check-markdown-accessibility.sh
./tests/check-landmark-one-main.sh
```

## WCAG 2.1 Compliance

These tests help ensure compliance with WCAG 2.1 requirements for:

- **H1 headings** (`page-has-heading-one`): Pages should have a level-one heading. This is important for screen reader navigation and document structure.
- **Main landmark** (`landmark-one-main`): Pages must have exactly one `<main>` landmark element. On GitHub-rendered markdown pages, GitHub provides the `<main>` landmark via its page template. Markdown files must not introduce additional `<main>` elements via inline HTML, which would create duplicate main landmarks and violate this rule.

## References

- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [Deque University: Landmark One Main](https://dequeuniversity.com/rules/axe/4.11/landmark-one-main)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

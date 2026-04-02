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
Checks all markdown files in the repository for the landmark-one-main accessibility requirement (axe-core rule). GitHub renders each markdown file inside its own `<main>` landmark, so this test verifies that markdown files do not embed additional `<main>` HTML elements or `role="main"` attributes that would create duplicate landmarks and trigger the violation.

**Usage:**
```bash
./tests/check-landmark-one-main.sh
```

**Expected Output:**
```
✅ All markdown files pass landmark-one-main compliance
   GitHub's rendering provides exactly one <main> landmark per page.
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

These tests help ensure compliance with WCAG 2.1 accessibility requirements. This is important for:
- Screen reader navigation
- Document structure and semantics
- Accessibility scanning tools

### Covered Rules
| Rule | Test Script | Description |
|------|-------------|-------------|
| `page-has-heading-one` | `check-markdown-accessibility.sh` | Each page must have a level-one heading (`<h1>`) |
| `landmark-one-main` | `check-landmark-one-main.sh` | Each page must have exactly one `<main>` landmark |

## References

- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [Deque University: Landmark One Main](https://dequeuniversity.com/rules/axe/4.11/landmark-one-main)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

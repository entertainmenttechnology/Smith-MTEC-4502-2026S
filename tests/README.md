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

### check-link-in-text-block.sh
Checks markdown files for inline links (`[text](url)`) that are embedded within
prose paragraphs. Such links may trigger the axe `link-in-text-block` rule if they
cannot be distinguished from surrounding text without relying on color alone (WCAG 2.1 SC 1.4.1).

Run against all files:
```bash
./tests/check-link-in-text-block.sh
```

Run against a single file:
```bash
./tests/check-link-in-text-block.sh resources/11_resume_development_guide.md
```

**Expected Output for `resources/11_resume_development_guide.md`:**
```
✅ resources/11_resume_development_guide.md (no inline links in text blocks)
```

When inline links are found, the script reports which lines need review and suggests
how to make links distinguishable without relying on color (e.g. place the link on
its own line, add a non-color visual label, or ensure the rendering engine shows
underlines on the link).

## Running Tests

To run all accessibility tests:
```bash
cd /path/to/repository
./tests/test-student-folder-template-heading.sh
./tests/check-markdown-accessibility.sh
./tests/check-link-in-text-block.sh
```

## WCAG 2.1 Compliance

These tests help ensure compliance with the following WCAG 2.1 requirements:

| Test | WCAG Criterion | Axe Rule |
|------|---------------|----------|
| `check-markdown-accessibility.sh` | Level A – Page titled / heading structure | `page-has-heading-one` |
| `check-link-in-text-block.sh` | SC 1.4.1 – Use of Color | `link-in-text-block` |

This is important for:
- Screen reader navigation
- Document structure and semantics
- Accessibility scanning tools

## References

- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [Deque University: Link in Text Block](https://dequeuniversity.com/rules/axe/4.11/link-in-text-block)
- [WCAG 2.1 SC 1.4.1 – Use of Color](https://www.w3.org/WAI/WCAG21/Understanding/use-of-color.html)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

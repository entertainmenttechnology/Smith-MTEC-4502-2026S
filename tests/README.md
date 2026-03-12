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
Checks all markdown files in the repository for link-in-text-block accessibility issues (WCAG 2.1 / axe rule: `link-in-text-block`). Links in text blocks must be distinguishable from surrounding text without relying on color alone.

This script detects:
- Raw HTML `<a>` tags inside gray color-styled `<span>` elements (insufficient contrast)
- Empty HTML `<a>` tags (no visible link text)

> **Note on GitHub UI elements:** GitHub's own interface includes a
> `<a href="/login">Signing in</a>` element that is shown only to
> unauthenticated visitors. This element exists in a gray-text block and has
> insufficient color contrast (1.29:1) between the link color (#0366d6) and
> the surrounding text (#7b7c7d). It also lacks non-color visual distinction
> (no underline). This is GitHub's own UI, not markdown content — it cannot
> be fixed by editing the markdown files. To prevent the accessibility
> scanner from flagging it, configure the scanner to authenticate with GitHub
> (see `.github/workflows/accessibility-scan.yml`).

**Usage:**
```bash
./tests/check-link-accessibility.sh
```

**Expected Output:**
```
✅ No link-in-text-block accessibility issues found in markdown content
```

## Running Tests

To run all accessibility tests:
```bash
cd /path/to/repository
./tests/test-student-folder-template-heading.sh
./tests/check-markdown-accessibility.sh
./tests/check-link-accessibility.sh
```

## WCAG 2.1 Compliance

These tests help ensure compliance with WCAG 2.1 requirements. Key rules covered:

| Rule | Test Script | Description |
|------|-------------|-------------|
| `page-has-heading-one` | `check-markdown-accessibility.sh` | Pages must have a level-one heading |
| `page-has-heading-one` | `test-student-folder-template-heading.sh` | Specific check for template file |
| `link-in-text-block` | `check-link-accessibility.sh` | Links in text blocks must be distinguishable without relying on color |

### Why links must be distinguishable without relying on color

The WCAG 2.1 `link-in-text-block` guideline requires that links within blocks of text can be identified without relying on color alone. To meet this requirement, links should either:
1. Have a **color contrast ratio of at least 3:1** between the link text color and the surrounding text color, **OR**
2. Have a **non-color visual distinction** such as underline, border, or background color

Standard GitHub Flavored Markdown (GFM) links using `[text](url)` syntax are rendered by GitHub with underlines in prose/body contexts, so they naturally satisfy this requirement. Avoid placing raw HTML `<a>` tags inside color-styled inline elements.

## References

- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [Deque University: Link In Text Block](https://dequeuniversity.com/rules/axe/4.11/link-in-text-block)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [WCAG 2.1 Success Criterion 1.4.1 (Use of Color)](https://www.w3.org/WAI/WCAG21/Understanding/use-of-color)

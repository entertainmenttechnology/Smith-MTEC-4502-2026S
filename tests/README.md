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

### check-link-in-text-block-accessibility.sh
Checks all markdown files for links embedded in paragraph text that use non-descriptive anchor text (e.g. "here", "click here", "read more"). Non-descriptive anchor text violates WCAG 2.1 Success Criterion 2.4.4 (Link Purpose) and contributes to the axe `link-in-text-block` rule, because users cannot distinguish or understand such links without relying solely on context or color.

**Usage:**
```bash
./tests/check-link-in-text-block-accessibility.sh
```

**Expected Output:**
```
✅ All inline links in text blocks have descriptive anchor text
```

## Running Tests

To run all accessibility tests:
```bash
cd /path/to/repository
./tests/test-student-folder-template-heading.sh
./tests/check-markdown-accessibility.sh
./tests/check-link-in-text-block-accessibility.sh
```

## WCAG 2.1 Compliance

These tests help ensure compliance with WCAG 2.1 guidelines. This is important for:
- Screen reader navigation
- Document structure and semantics
- Accessibility scanning tools

### Rules covered

| Test script | WCAG criterion | axe rule |
|---|---|---|
| `check-markdown-accessibility.sh` | 1.3.1 Info and Relationships / 2.4.6 Headings and Labels | `page-has-heading-one` |
| `test-student-folder-template-heading.sh` | 1.3.1 Info and Relationships / 2.4.6 Headings and Labels | `page-has-heading-one` |
| `check-link-in-text-block-accessibility.sh` | 2.4.4 Link Purpose (In Context) | `link-in-text-block` |

## References

- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [Deque University: Link In Text Block](https://dequeuniversity.com/rules/axe/4.11/link-in-text-block)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

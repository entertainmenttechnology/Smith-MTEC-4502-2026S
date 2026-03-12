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

### check-link-distinguishability.sh
Checks all markdown files to ensure inline links within paragraph text are distinguishable from surrounding text without relying solely on color. This addresses the WCAG 2.1 `link-in-text-block` accessibility rule.

Links must be distinguished by more than color (e.g., bold formatting, or placed on their own line). Links that appear only in a different color from surrounding text fail this check.

**Usage:**
```bash
./tests/check-link-distinguishability.sh
```

**Expected Output:**
```
✅ All inline links appear to have distinguishing formatting
```

**To fix a violation:** Wrap inline links in bold formatting:
```markdown
<!-- Before (fails) -->
See the [documentation](https://example.com) for details.

<!-- After (passes) -->
See the **[documentation](https://example.com)** for details.
```

## Running Tests

To run all accessibility tests:
```bash
cd /path/to/repository
./tests/test-student-folder-template-heading.sh
./tests/check-markdown-accessibility.sh
./tests/check-link-distinguishability.sh
```

## WCAG 2.1 Compliance

These tests help ensure compliance with WCAG 2.1 requirements:

- **page-has-heading-one**: Pages should have a level-one heading for screen reader navigation.
- **link-in-text-block**: Links within blocks of text must be distinguishable from surrounding text by more than color alone. This is important for users with color vision deficiencies.

## References

- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [Deque University: Link in Text Block](https://dequeuniversity.com/rules/axe/4.11/link-in-text-block)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

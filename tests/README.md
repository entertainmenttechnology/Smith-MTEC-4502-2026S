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

### check-markdown-link-accessibility.sh
Checks all markdown files in the repository to ensure links use descriptive text and meet WCAG 2.1 SC 1.4.1 (Use of Color) and SC 2.4.4 (Link Purpose) requirements. Links must be distinguishable without relying on color alone.

**Usage:**
```bash
./tests/check-markdown-link-accessibility.sh
```

**Expected Output:**
```
✅ resources/speculative_future_careers.md (no links)
✅ resources/02_Resources.md (5 link(s) with descriptive text)
...
✅ All markdown links meet accessibility requirements
```

### test-speculative-future-careers-links.sh
Specific test for `resources/speculative_future_careers.md` to ensure all links in the file use descriptive text and meet WCAG 2.1 link accessibility requirements (SC 1.4.1, SC 2.4.4). Addresses the `link-in-text-block` axe accessibility rule.

**Usage:**
```bash
./tests/test-speculative-future-careers-links.sh
```

**Expected Output:**
```
✅ resources/speculative_future_careers.md: No links found - no link accessibility issues
```

## Running Tests

To run all accessibility tests:
```bash
cd /path/to/repository
./tests/test-student-folder-template-heading.sh
./tests/check-markdown-accessibility.sh
./tests/check-markdown-link-accessibility.sh
./tests/test-speculative-future-careers-links.sh
```

## WCAG 2.1 Compliance

These tests help ensure compliance with:
- **WCAG 2.1 Level A** - pages should have a level-one heading (page-has-heading-one)
- **WCAG 2.1 SC 1.4.1** (Use of Color) - links must be distinguishable without relying on color alone
- **WCAG 2.1 SC 2.4.4** (Link Purpose) - link text must describe the link destination

Link accessibility is especially important for:
- Users with color vision deficiencies who cannot distinguish links by color alone
- Screen reader users who navigate by links
- Users with cognitive disabilities who benefit from descriptive link text

## References

- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [Deque University: Links Must Be Distinguishable](https://dequeuniversity.com/rules/axe/4.11/link-in-text-block?application=playwright)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [WCAG 2.1 SC 1.4.1 Use of Color](https://www.w3.org/WAI/WCAG21/Understanding/use-of-color)
- [WCAG 2.1 SC 2.4.4 Link Purpose](https://www.w3.org/WAI/WCAG21/Understanding/link-purpose-in-context)

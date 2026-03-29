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

## Running Tests

To run all accessibility tests:
```bash
cd /path/to/repository
./tests/test-student-folder-template-heading.sh
./tests/check-markdown-accessibility.sh
./tests/test-links-have-discernible-text.sh
```

### test-links-have-discernible-text.sh
Tests that `assignments/01a_Reflective_essay_draft_speculation_phase.md` contains no links with empty or missing text, as required by WCAG 2.1 (link-name rule).

**Usage:**
```bash
./tests/test-links-have-discernible-text.sh
```

**Expected Output:**
```
✅ assignments/01a_Reflective_essay_draft_speculation_phase.md has no links with missing discernible text
   All links (if any) have descriptive text — WCAG 2.1 link-name rule satisfied
```

## WCAG 2.1 Compliance

These tests help ensure compliance with WCAG 2.1 Level A requirements:
- Pages should have a level-one heading (page-has-heading-one rule)
- Links must have discernible text (link-name rule)

This is important for:
- Screen reader navigation
- Document structure and semantics
- Accessibility scanning tools

## References

- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [Deque University: Link Name](https://dequeuniversity.com/rules/axe/4.11/link-name)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

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

### check-link-names.sh
Checks all markdown files in the repository to ensure every link has discernible text (non-empty link text between brackets). This addresses the WCAG 2.1 Success Criterion 2.4.4 (Link Purpose) and the axe `link-name` accessibility rule.

**Usage:**
```bash
./tests/check-link-names.sh
```

**Expected Output:**
```
✅ ./assignments/01c2-mtec_4502_assignment_1c_part2_future_modeling_and_adaptive_planning.md
✅ All markdown links have discernible text
```

## Running Tests

To run all accessibility tests:
```bash
cd /path/to/repository
./tests/test-student-folder-template-heading.sh
./tests/check-markdown-accessibility.sh
./tests/check-link-names.sh
```

## WCAG 2.1 Compliance

These tests help ensure compliance with:
- WCAG 2.1 Level A requirement that pages should have a level-one heading
- WCAG 2.1 Success Criterion 2.4.4 requiring links to have discernible, descriptive text

This is important for:
- Screen reader navigation
- Document structure and semantics
- Accessibility scanning tools

## References

- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [Deque University: Link Name](https://dequeuniversity.com/rules/axe/4.11/link-name)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

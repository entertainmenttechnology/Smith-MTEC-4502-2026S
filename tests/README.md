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

### check-markdown-link-names.sh
Checks all markdown files in the repository for links with discernible (non-empty) text, addressing the WCAG 2.1 link-name rule. Detects:
- Links with empty text: `[](url)`
- Links with whitespace-only text: `[   ](url)`
- Image links with empty alt text: `[![](img)](url)`

**Usage:**
```bash
./tests/check-markdown-link-names.sh
```

**Expected Output:**
```
✅ ./README.md
✅ ./course-materials/12-Lesson_Plan_Future_Careers_AI_Skill_Mapping_2026-03-12.md
...
✅ All markdown links have discernible text
```

## Running Tests

To run all accessibility tests:
```bash
cd /path/to/repository
./tests/test-student-folder-template-heading.sh
./tests/check-markdown-accessibility.sh
./tests/check-markdown-link-names.sh
```

## WCAG 2.1 Compliance

These tests help ensure compliance with the following WCAG 2.1 Level A requirements:
- **page-has-heading-one**: Pages must contain a level-one heading for screen reader navigation
- **link-name**: All links must have discernible text so screen readers can identify their purpose

This is important for:
- Screen reader navigation
- Document structure and semantics
- Accessibility scanning tools

## References

- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [Deque University: Link Name](https://dequeuniversity.com/rules/axe/4.11/link-name)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

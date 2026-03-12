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

### test-lesson-plan-region-accessibility.sh
Tests that `course-materials/12-Lesson_Plan_Future_Careers_AI_Skill_Mapping_2026-03-12.md` is structured correctly so all content renders within landmark regions when served by GitHub (axe `region` rule, WCAG 2.1).

**Usage:**
```bash
./tests/test-lesson-plan-region-accessibility.sh
```

**Expected Output:**
```
✅ File exists: course-materials/12-Lesson_Plan_Future_Careers_AI_Skill_Mapping_2026-03-12.md
✅ Has level-one heading: # MTEC 4502 - Career and Portfolio Seminar
✅ File has sufficient content (196 non-empty lines)
✅ No bare top-level HTML block elements that could render outside landmarks
✅ course-materials/12-Lesson_Plan_Future_Careers_AI_Skill_Mapping_2026-03-12.md passes region/landmark accessibility checks
```

## Running Tests

To run all accessibility tests:
```bash
cd /path/to/repository
./tests/test-student-folder-template-heading.sh
./tests/check-markdown-accessibility.sh
./tests/test-lesson-plan-region-accessibility.sh
```

## WCAG 2.1 Compliance

These tests help ensure compliance with WCAG 2.1 Level A requirement that pages should have a level-one heading. This is important for:
- Screen reader navigation
- Document structure and semantics
- Accessibility scanning tools

## References

- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [Deque University: Region Rule](https://dequeuniversity.com/rules/axe/4.11/region?application=playwright)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

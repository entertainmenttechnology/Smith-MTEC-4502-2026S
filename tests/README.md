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

### test-resume-guide-lang.sh
Tests that `resources/11_resume_development_guide.md` contains a `lang` attribute in its YAML frontmatter, required for WCAG 2.1 SC 3.1.1 (Language of Page / html-has-lang rule).

**Usage:**
```bash
./tests/test-resume-guide-lang.sh
```

**Expected Output:**
```
✅ resources/11_resume_development_guide.md has lang attribute in frontmatter
   lang: en
```

## Running Tests

To run all accessibility tests:
```bash
cd /path/to/repository
./tests/test-student-folder-template-heading.sh
./tests/check-markdown-accessibility.sh
./tests/test-resume-guide-lang.sh
```

## WCAG 2.1 Compliance

These tests help ensure compliance with WCAG 2.1 requirements:
- **Level A – 1.3.1 / page-has-heading-one**: Pages should have a level-one heading. Important for screen reader navigation and document structure.
- **Level A – 3.1.1 / html-has-lang**: The human language of each web page must be programmatically determinable. Important for screen readers to use the correct language rules and pronunciation.

## References

- [Deque University: Page Has Heading One](https://dequeuniversity.com/rules/axe/4.11/page-has-heading-one)
- [Deque University: HTML Has Lang](https://dequeuniversity.com/rules/axe/4.11/html-has-lang)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

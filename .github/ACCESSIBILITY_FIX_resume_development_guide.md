# Accessibility Fix: Link-in-Text-Block for resources/11_resume_development_guide.md

## Issue Summary
An accessibility scan flagged `<a href="/login">Signing in</a>` on the GitHub-rendered
page for `resources/11_resume_development_guide.md`.

The axe rule `link-in-text-block` fires when a hyperlink appears within a block of
prose text and cannot be distinguished from the surrounding text without relying on
color alone (WCAG 2.1 SC 1.4.1).

**Details from the scan:**
- Element: `<a href="/login">Signing in</a>`
- Link color: `#0366d6`
- Surrounding text color: `#7b7c7d` (muted gray)
- Contrast ratio: 1.29:1 (minimum required: 3:1)
- Rule: [link-in-text-block](https://dequeuniversity.com/rules/axe/4.11/link-in-text-block?application=playwright)

## Investigation

### Root Cause
The flagged element **is not part of the markdown file content**. It is a
GitHub platform UI element — the "Signing in" notice that GitHub renders on
repository file pages for unauthenticated visitors.

The notice appears below/around the file content and uses GitHub's standard
muted-text color (`#7b7c7d`) as surrounding text. The link (`#0366d6`) does
not have sufficient contrast against that muted color and has no underline or
other non-color visual indicator in this specific rendering context.

### Markdown file analysis
Running the new `tests/check-link-in-text-block.sh` test against the file confirms:

```
✅ resources/11_resume_development_guide.md (no inline links in text blocks)
```

The file itself contains **no inline hyperlinks** (`[text](url)` patterns) inside
prose paragraphs. All references to external platforms (LinkedIn, GitHub, Jobscan,
etc.) are plain text, not hyperlinks. Therefore, no link-in-text-block violations
originate from the file's own content.

## Solution Implemented

Because the violation originates from GitHub's own UI rather than the markdown file
content, it cannot be fixed by editing the markdown file. Instead:

1. **Test script** (`tests/check-link-in-text-block.sh`):
   - Scans markdown files for inline links embedded in prose paragraphs
   - Warns authors when links may need additional non-color visual cues
   - Can target a single file or the entire repository
   - Verifies `resources/11_resume_development_guide.md` has no inline links in
     text blocks (exit code 0 = pass)

2. **Updated tests README** (`tests/README.md`):
   - Documents the new test and its relation to `link-in-text-block` / WCAG 2.1 SC 1.4.1
   - Links to Deque University documentation for the rule

### Guidelines for authors adding links in the future
To avoid `link-in-text-block` violations in markdown content:

| ✅ Accessible pattern | ❌ Problematic pattern |
|---|---|
| Link on its own list line: `- [Resource Name](url)` | Link buried in sentence: `See [here](url) for details.` |
| Standalone reference line: `📎 [Link label](url)` | Inline link in caption-style (muted) text |
| Links that the rendering engine decorates with an underline | Plain linked word with no underline, in gray/muted context |

> **Note:** Ensure your links are rendered with underlines or other non-color
> text decorations. On GitHub.com, standard markdown links (`[text](url)`) in
> regular body text do carry underlines, which satisfies the non-color requirement.
> The violation in this issue arose from a GitHub UI element (the sign-in notice)
> where underlines were absent in the muted-text rendering context.

## Testing

```bash
# Verify resources/11_resume_development_guide.md passes
./tests/check-link-in-text-block.sh resources/11_resume_development_guide.md
# Expected: ✅ resources/11_resume_development_guide.md (no inline links in text blocks)

# Run across the full repository
./tests/check-link-in-text-block.sh
```

## Acceptance Criteria Status
- [x] Test confirms the file itself introduces no link-in-text-block violations
- [x] Fix meets WCAG 2.1 SC 1.4.1 (no color-only link distinction in our content)
- [x] Regression test added (`tests/check-link-in-text-block.sh`)
- [x] No new accessibility issues introduced

# Accessibility Tests

This directory contains tests to ensure the course materials meet accessibility standards.

## Heading Hierarchy Tests

### Problem
When markdown files are rendered on GitHub, the platform adds its own UI elements, including an H4-level "Sign in to GitHub" prompt. If a markdown file ends with an H1 or H2 heading, this creates a heading level jump (e.g., H2 → H4), which violates WCAG 2.1 accessibility guidelines.

### Solution
Ensure that markdown files end with an H3 (or lower) heading, so that when GitHub adds its H4 UI element, the progression is valid (H3 → H4).

## Running the Tests

### Simple Test
Checks if the specific file ends with H3 or lower:
```bash
./tests/test-heading-hierarchy.sh
```

### Comprehensive Test
Validates the entire heading structure:
```bash
./tests/validate-heading-structure.sh
```

## Test Files

- `test-heading-hierarchy.sh` - Quick check for the last heading level
- `validate-heading-structure.sh` - Full heading hierarchy validation, checking for:
  - No level jumps (e.g., H1 → H3)
  - Proper final heading level (H3 or lower)

## WCAG Guidelines

These tests help ensure compliance with:
- WCAG 2.1 Level A: [1.3.1 Info and Relationships](https://www.w3.org/WAI/WCAG21/Understanding/info-and-relationships.html)
- Axe rule: [heading-order](https://dequeuniversity.com/rules/axe/4.11/heading-order)

Heading levels should only increase by one level at a time (e.g., H1 → H2 → H3, not H1 → H3).

#!/usr/bin/env python3
"""
Test script to verify that specific markdown files have a level-one heading.
This helps ensure accessibility compliance for the course materials.

This test specifically checks the file mentioned in the accessibility issue:
assignments/01a_Reflective_essay_draft_speculation_phase.md
"""

import sys
import re
from pathlib import Path

def has_level_one_heading(filepath):
    """
    Check if a markdown file has a level-one heading.
    
    For accessibility compliance, checks if the first non-empty line is an H1.
    """
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
            lines = content.split('\n')
            
            # Check if first non-empty line is a level-one heading
            for line in lines:
                stripped = line.strip()
                if stripped:  # First non-empty line
                    # Match: starts with # followed by space, but not ##
                    # Using negative lookahead to ensure it's not ##
                    if re.match(r'^# (?!#)', stripped):
                        return True, f"Found H1: {stripped[:60]}"
                    else:
                        return False, f"First non-empty line is not H1: {stripped[:60]}"
    except Exception as e:
        return False, f"Error reading file: {e}"
    
    return False, "File is empty or has no content"

def main():
    """Test the specific file mentioned in the accessibility issue."""
    repo_root = Path(__file__).parent.parent.parent
    
    # The specific file mentioned in the accessibility issue
    target_file = repo_root / "assignments" / "01a_Reflective_essay_draft_speculation_phase.md"
    
    if not target_file.exists():
        print(f"❌ Target file not found: {target_file}")
        return 1
    
    print(f"Testing: {target_file.name}")
    print(f"{'='*60}")
    
    has_h1, message = has_level_one_heading(target_file)
    
    if has_h1:
        print(f"✅ PASS: File has a level-one heading")
        print(f"   {message}")
        print(f"\n✅ Accessibility requirement met:")
        print(f"   The page contains a level-one heading as required by WCAG 2.1")
        return 0
    else:
        print(f"❌ FAIL: File missing level-one heading")
        print(f"   {message}")
        print(f"\n❌ Accessibility violation:")
        print(f"   Page must have a level-one heading (axe rule: page-has-heading-one)")
        return 1

if __name__ == "__main__":
    sys.exit(main())

#!/usr/bin/env python3
"""
Test script to verify that all markdown files have a level-one heading.
This helps ensure accessibility compliance.
"""

import sys
import re
from pathlib import Path

def has_level_one_heading(filepath):
    """Check if a markdown file has a level-one heading."""
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
            lines = content.split('\n')
            
            # Check for a level-one heading (# but not ##, ###, etc.)
            for line in lines:
                stripped = line.strip()
                if stripped:  # First non-empty line
                    # Match: starts with # followed by space, but not ##
                    if re.match(r'^# [^#]', line):
                        return True, f"Found H1: {line[:60]}"
                    else:
                        return False, f"First non-empty line is not H1: {line[:60]}"
    except Exception as e:
        return False, f"Error reading file: {e}"
    
    return False, "File is empty or has no content"

def main():
    """Test all markdown files in assignments directory."""
    repo_root = Path(__file__).parent.parent.parent
    assignments_dir = repo_root / "assignments"
    
    if not assignments_dir.exists():
        print(f"❌ Assignments directory not found: {assignments_dir}")
        return 1
    
    md_files = list(assignments_dir.glob("*.md"))
    
    if not md_files:
        print("No markdown files found in assignments directory")
        return 0
    
    failures = []
    successes = []
    
    for md_file in sorted(md_files):
        has_h1, message = has_level_one_heading(md_file)
        
        if has_h1:
            successes.append(md_file.name)
            print(f"✅ {md_file.name}")
            print(f"   {message}")
        else:
            failures.append((md_file.name, message))
            print(f"❌ {md_file.name}")
            print(f"   {message}")
    
    print(f"\n{'='*60}")
    print(f"Total files checked: {len(md_files)}")
    print(f"✅ Passed: {len(successes)}")
    print(f"❌ Failed: {len(failures)}")
    
    if failures:
        print("\nFiles missing level-one headings:")
        for filename, message in failures:
            print(f"  - {filename}: {message}")
        return 1
    
    return 0

if __name__ == "__main__":
    sys.exit(main())

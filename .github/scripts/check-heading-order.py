#!/usr/bin/env python3
"""
Check heading order in markdown files to ensure WCAG 2.1 compliance.
Heading levels should only increase by one.
"""

import sys
import re
from pathlib import Path

# ANSI color codes
RED = '\033[0;31m'
GREEN = '\033[0;32m'
YELLOW = '\033[1;33m'
NC = '\033[0m'  # No Color

def check_heading_order(file_path):
    """Check a single markdown file for heading order issues."""
    errors = []
    warnings = []
    
    with open(file_path, 'r', encoding='utf-8') as f:
        lines = f.readlines()
    
    prev_level = 0
    heading_pattern = re.compile(r'^(#+)\s+(.+)$')
    
    for line_num, line in enumerate(lines, 1):
        match = heading_pattern.match(line)
        if match:
            current_level = len(match.group(1))
            heading_text = match.group(2).strip()
            
            if prev_level == 0:
                # First heading should be H1
                if current_level != 1:
                    warnings.append(
                        f"  {YELLOW}Warning:{NC} Line {line_num}: "
                        f"Document should start with H1, found H{current_level}\n"
                        f"    {line.strip()}"
                    )
            else:
                # Check if heading level increases by more than 1
                level_diff = current_level - prev_level
                if level_diff > 1:
                    errors.append(
                        f"  {RED}Error:{NC} Line {line_num}: "
                        f"Heading level skipped from H{prev_level} to H{current_level}\n"
                        f"    {line.strip()}\n"
                        f"    Heading levels should only increase by one"
                    )
            
            prev_level = current_level
    
    return errors, warnings

def main():
    """Main function to check all markdown files."""
    print("Checking heading order in markdown files...")
    print()
    
    # Find all markdown files (excluding .git directory)
    all_errors = []
    all_warnings = []
    
    md_files = sorted(Path('.').rglob('*.md'))
    md_files = [f for f in md_files if '.git' not in str(f)]
    
    for file_path in md_files:
        print(f"Checking: {file_path}")
        errors, warnings = check_heading_order(file_path)
        
        if errors:
            all_errors.extend(errors)
            for error in errors:
                print(error)
        
        if warnings:
            all_warnings.extend(warnings)
            for warning in warnings:
                print(warning)
    
    print()
    print("=" * 32)
    
    if not all_errors and not all_warnings:
        print(f"{GREEN}✓ All checks passed!{NC}")
        return 0
    elif not all_errors:
        print(f"{YELLOW}⚠ Completed with {len(all_warnings)} warning(s){NC}")
        return 0
    else:
        print(f"{RED}✗ Found {len(all_errors)} error(s) and {len(all_warnings)} warning(s){NC}")
        return 1

if __name__ == '__main__':
    sys.exit(main())

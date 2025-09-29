#!/usr/bin/env python3
"""
LaTeX Template Configuration Wizard
Helps users set up their thesis information easily.
"""

import os
import sys
import re
from pathlib import Path

def read_config():
    """Read current configuration from config.tex"""
    config_file = Path("config.tex")
    if not config_file.exists():
        print("Error: config.tex not found!")
        return {}

    config = {}
    with open(config_file, 'r') as f:
        content = f.read()

    # Extract current values using regex
    patterns = {
        'authorname': r'\\newcommand\{\\authorname\}\{([^}]+)\}',
        'authorcity': r'\\newcommand\{\\authorcity\}\{([^}]+)\}',
        'thesisname': r'\\newcommand\{\\thesisname\}\{([^}]+)\}',
        'kindofthesis': r'\\newcommand\{\\kindofthesis\}\{([^}]+)\}',
        'titlename': r'\\newcommand\{\\titlename\}\{([^}]+)\}',
        'advisorname': r'\\newcommand\{\\advisorname\}\{([^}]+)\}',
        'advisormail': r'\\newcommand\{\\advisormail\}\{([^}]+)\}',
        'coadvisorname': r'\\newcommand\{\\coadvisorname\}\{([^}]+)\}',
        'coadvisormail': r'\\newcommand\{\\coadvisormail\}\{([^}]+)\}',
        'expertname': r'\\newcommand\{\\expertname\}\{([^}]+)\}',
        'expertmail': r'\\newcommand\{\\expertmail\}\{([^}]+)\}',
    }

    for key, pattern in patterns.items():
        match = re.search(pattern, content)
        if match:
            config[key] = match.group(1)

    return config

def write_config(config):
    """Write configuration back to config.tex"""
    config_file = Path("config.tex")

    with open(config_file, 'r') as f:
        content = f.read()

    # Replace each configuration value
    for key, value in config.items():
        pattern = f'(\\\\newcommand{{\\\\{key}}}{{)[^}}]+(}})'
        replacement = f'\\g<1>{value}\\g<2>'
        content = re.sub(pattern, replacement, content)

    with open(config_file, 'w') as f:
        f.write(content)

def main():
    print("=" * 50)
    print("LaTeX VM Report Template Configuration Wizard")
    print("=" * 50)
    print()

    current_config = read_config()
    new_config = {}

    # Configuration prompts
    questions = [
        ('authorname', 'Your full name', 'John Doe'),
        ('authorcity', 'Your city', 'Zurich'),
        ('thesisname', 'Thesis title', 'My Amazing Research Project'),
        ('kindofthesis', 'Type of thesis', 'Master Thesis'),
        ('titlename', 'Degree title', 'Master of Science in Engineering'),
        ('advisorname', 'Advisor name', 'Prof. Dr. Jane Smith'),
        ('advisormail', 'Advisor email', 'jane.smith@university.com'),
        ('coadvisorname', 'Co-advisor name', 'Dr. John Wilson'),
        ('coadvisormail', 'Co-advisor email', 'john.wilson@university.com'),
        ('expertname', 'Expert name', 'Dr. Expert Name'),
        ('expertmail', 'Expert email', 'expert@company.com'),
    ]

    for key, prompt, example in questions:
        current = current_config.get(key, '')
        if current in ['Your Name', 'Your City', 'Your Thesis Title', 'Advisor Name', 'advisor@university.com', 'Co-Advisor Name', 'coadvisor@university.com', 'Expert Name', 'expert@company.com']:
            current = ''

        print(f"{prompt}:")
        if current:
            print(f"  Current: {current}")
        print(f"  Example: {example}")

        value = input("  Enter value (or press Enter to keep current): ").strip()

        if value:
            new_config[key] = value
        elif current:
            new_config[key] = current
        else:
            new_config[key] = example

        print()

    # Show summary
    print("=" * 50)
    print("Configuration Summary:")
    print("=" * 50)
    for key, value in new_config.items():
        print(f"{key}: {value}")

    print()
    confirm = input("Save this configuration? [Y/n]: ").strip().lower()

    if confirm in ['', 'y', 'yes']:
        write_config(new_config)
        print("✅ Configuration saved to config.tex")
        print()
        print("Next steps:")
        print("1. Review your configuration in config.tex")
        print("2. Run 'make build' to compile your thesis")
        print("3. Check the generated PDF")
    else:
        print("❌ Configuration not saved.")

if __name__ == "__main__":
    main()
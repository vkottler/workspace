#!/usr/bin/env python

"""
A simple script to generate Python documentation for each python project.
"""

# built-in
import sys

# internal
from workspace.data import configs


def main() -> int:
    """Script entry."""

    print(configs())
    return 0


if __name__ == "__main__":
    sys.exit(main())

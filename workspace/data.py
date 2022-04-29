"""
A module for working with workspace data.
"""

# built-in
from functools import lru_cache
from pathlib import Path

# third-party
from vcorelib.io import ARBITER

ROOT = Path(__file__).resolve().parent.parent
LOCAL = ROOT.joinpath("local")


@lru_cache
def configs(item: str = "configs", **kwargs) -> dict:
    """Load workspace configuration data."""

    return ARBITER.decode_directory(
        LOCAL.joinpath(item), require_success=True, recurse=True, **kwargs
    ).data

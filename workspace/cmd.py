"""
A module for working with command-line tasks.
"""

# built-in
from functools import lru_cache
from os import environ
from pathlib import Path
from subprocess import CompletedProcess, run
from typing import List

# third-party
from vcorelib.dict import consume

# internal
from workspace.data import ROOT


def cmd(args: List[str], log: bool = True, **kwargs) -> CompletedProcess:
    """Run a command."""
    if log:
        print(f"cmd: {' '.join(args)}")
    return run(args, check=consume(kwargs, "check", True), **kwargs)


def mk_cmd(args: List[str], location: Path, **kwargs) -> CompletedProcess:
    """Run an 'mk' command."""
    return cmd(["mk", "-C", str(location)] + args, **kwargs)


@lru_cache
def venv(root: Path = ROOT, default_version: str = "3.8", **kwargs) -> Path:
    """Get the path to this workspace's virtual environment repository."""

    loc = root.joinpath(
        f"venv{environ.get('PYTHON_VERSION', default_version)}"
    )
    if not loc.is_dir():
        mk_cmd(["venv"], root, **kwargs)

    return loc


@lru_cache
def python(**kwargs) -> str:
    """
    Get the path to the Python binary in the workspace virtual environment.
    """
    return str(venv(**kwargs).joinpath("bin", "python"))


def python_cmd(
    args: List[str],
    module: str = None,
    location: Path = None,
    cmd_args: dict = None,
    **kwargs,
) -> CompletedProcess:
    """Run a 'python' command."""

    if cmd_args is None:
        cmd_args = {}
    entry = []

    # Change locations when running the command.
    if location is not None:
        entry.append("cd")
        entry.append(str(location))
        entry.append("&&")
        entry.append("exec")

    entry.append(python(**kwargs))
    if module is not None:
        entry.append("-m")
        entry.append(module)

    all_args = entry + args
    shell = location is not None
    return cmd(
        all_args if not shell else [" ".join(all_args)],
        shell=shell,
        **cmd_args,
    )

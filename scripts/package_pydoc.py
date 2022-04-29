#!/usr/bin/env python

"""
A simple script to generate Python documentation for each python project.
"""

# built-in
from multiprocessing import Pool
from os import walk
from pathlib import Path
from shutil import move
import sys
from typing import Iterator, Tuple

# third-party
from git import Repo

# internal
from workspace.cmd import python_cmd
from workspace.git import get_python_submodules

PYDOC_DEST = Path.cwd().joinpath("vkottler.github.io", "python", "pydoc")


def python_sources(root: Path, pkg_slug: str) -> Iterator[Tuple[Path, Path]]:
    """Collect paths to all Python sources from a module root."""

    for path, _, files in walk(root.joinpath(pkg_slug)):
        if "__init__.py" in files:
            overlap = Path(path).relative_to(root)
            for name in files:
                if name.endswith(".py") and not name == "__main__.py":
                    py_file = Path(path, name)
                    yield (py_file, overlap)


def repo_entry(
    repo: Repo,
) -> None:
    """Perform common tasks on a Python, workspace repository."""

    root = Path(str(repo.working_tree_dir))
    pkg_slug = root.name.replace("-", "_")

    for source, rel in python_sources(root, pkg_slug):
        try:
            # Write the documentation and obtain the path to the output.
            python_cmd(
                ["-w", str(source)],
                "pydoc",
                root=root,
                location=root,
            )
            source_html_name = Path(source.name).with_suffix(".html")
            source_html = root.joinpath(source_html_name)

            dest = PYDOC_DEST.joinpath(rel)
            dest.mkdir(parents=True, exist_ok=True)
            dest_html = dest.joinpath(source_html_name)
            dest_html.unlink(True)

            # Move the generated file to the intended destination.
            move(str(source_html), str(dest_html))
        finally:
            source_html.unlink(True)


def main() -> int:
    """Script entry."""

    with Pool() as pool:
        pool.map(repo_entry, get_python_submodules(Path.cwd()))

    return 0


if __name__ == "__main__":
    sys.exit(main())

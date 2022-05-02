#!/usr/bin/env python

"""
A simple script to generate Python documentation for each python project.
"""

# built-in
from multiprocessing import Pool
from os import linesep, walk
from os.path import join
from pathlib import Path
from shutil import move, rmtree
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

    for source, _ in python_sources(root, pkg_slug):
        try:
            src_arg = source.parent.name

            # Add the relative path to the module root.
            src_curr = source.parent
            while src_curr.name != pkg_slug:
                if src_curr.name != source.parent.name:
                    src_arg = f"{src_curr.name}.{src_arg}"
                src_curr = src_curr.parent

            if src_arg != pkg_slug:
                src_arg = f"{pkg_slug}.{src_arg}"

            if source.name != "__init__.py":
                src_arg = f"{src_arg}.{Path(source.name).stem}"

            # Write the documentation and obtain the path to the output.
            python_cmd(
                ["-w", src_arg],
                "pydoc",
                root=root,
                location=root,
            )

            source_html_name = Path(f"{src_arg}.html")
            source_html = root.joinpath(source_html_name)

            dest_html = Path(PYDOC_DEST, source_html.name)
            dest_html.unlink(True)

            # Move the generated file to the intended destination.
            move(str(source_html), str(dest_html))
        finally:
            source_html.unlink(True)


def create_index(dest: Path) -> None:
    """Create the index.html file in the destination."""

    # Always completely re-generate the output.
    rmtree(dest, ignore_errors=True)
    dest.mkdir(parents=True)

    symlinks = []

    # Prepare to generate an index.html in the root.
    for submodule in get_python_submodules(Path.cwd()):
        root = Path(str(submodule.working_tree_dir))
        slug = root.name.replace("-", "_")
        symlink = dest.joinpath(slug)
        symlink.symlink_to(root.joinpath(slug), True)
        symlinks.append(symlink)

    # Generate an __init__.html and move it to index.html.
    init = dest.joinpath("__init__.py")
    with init.open("w", encoding="utf-8") as init_fd:
        for symlink in symlinks:
            init_fd.write(f"import {symlink.name}")
            init_fd.write(linesep)

    # Generate the output file.
    python_cmd(
        ["-w", join(".", "__init__.py")],
        "pydoc",
        location=dest,
    )
    init.unlink()
    move(str(init.with_suffix(".html")), dest.joinpath("index.html"))

    # Remove symbolic links.
    for symlink in symlinks:
        symlink.unlink()


def main() -> int:
    """Script entry."""

    create_index(PYDOC_DEST)
    with Pool() as pool:
        pool.map(repo_entry, get_python_submodules(Path.cwd()))

    return 0


if __name__ == "__main__":
    sys.exit(main())

#!/usr/bin/env python

"""
A simple script to update all of the submodules.
"""

# built-in
from multiprocessing import Pool
from pathlib import Path
from subprocess import CalledProcessError, run
import sys

# third-party
from git import Repo

# internal
from workspace.cmd import mk_cmd
from workspace.git import (
    DEFAULT_MAIN_BRANCH,
    DEFAULT_ORIGIN,
    get_submodules,
    repo_fetcher,
)


def repo_entry(
    repo: Repo,
    remote: str = DEFAULT_ORIGIN,
    main_branch: str = DEFAULT_MAIN_BRANCH,
) -> None:
    """Perform common tasks on a workspace repository."""

    # Update the repository.
    repo_fetcher(repo, remote, main_branch)

    # If it has a 'manifest.yaml' run datazen.
    repo_root = Path(str(repo.working_tree_dir))

    if repo_root.joinpath("manifest.yaml").is_file():
        try:
            result = run(["mk", "-C", str(repo_root), "dz-sync"], check=True)
            print(f"Syncing datazen result: {result.returncode}.")
        except CalledProcessError as exc:
            print(f"Failed to sync datazen ({repo_root.name}): {exc}")

    deps = repo_root.joinpath("im", "pydeps.svg")
    if deps.is_file():
        try:
            deps.unlink()
            result = mk_cmd(["docs python-deps"], repo_root, check=True)
            print(f"Generating docs/pydeps result: {result.returncode}.")
        except CalledProcessError as exc:
            print(f"Failed to generate docs/pydeps ({repo_root.name}): {exc}")

    print(f"Status for '{repo_root.name}':")
    for diff in repo.index.diff(None):
        print(diff)
    if repo.untracked_files:
        print(repo.untracked_files)


def main() -> int:
    """Script entry."""

    with Pool() as pool:
        pool.map(repo_entry, get_submodules(Path.cwd()))

    return 0


if __name__ == "__main__":
    sys.exit(main())

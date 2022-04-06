#!/usr/bin/env python

"""
pull_all - A simple script to update all of the submodules.
"""

# built-in
from multiprocessing import Pool
from pathlib import Path
import sys
from typing import Iterator

# third-party
from git import Repo


def get_submodules(start: Path) -> Iterator[Repo]:
    """Find all top-level submodules are contained by a start path."""

    for item in start.iterdir():
        if item.is_dir() and item.joinpath(".git").is_file():
            yield Repo(item)


def pull_config(repo: Repo, parent: str) -> None:
    """
    If a given repository has a 'config' submodule, try and pull the latest.
    """

    config_path = Path(str(repo.working_tree_dir), "config")
    if config_path.joinpath(".git").is_file():
        config = Repo(config_path)
        if config.is_dirty():
            print("Note: {parent}'s 'config' has local changes.")

        for remote in config.remotes:

            # Remove any HTTP[S] remotes.
            if remote.url.startswith("http"):
                print(
                    f"Repository '{parent}' has remote '{remote}' "
                    f"with URL '{remote.url}'."
                )

            # Ensure that 'origin' has the correct URI.


def repo_fetcher(repo: Repo, remote: str = "origin") -> None:
    """Fetch from a given remote for a repository."""

    if remote in repo.remotes:
        remote = repo.remotes[remote]
        name = Path(str(repo.working_tree_dir)).name

        dirty = repo.is_dirty()
        if dirty:
            print("Note: '{name}' has local changes.")
        fetcher = "fetch" if dirty else "pull"

        # Pull from the remote.
        print(f"Running '{fetcher}' on '{name}'.")
        for info in getattr(remote, fetcher)():
            if info.note:
                print(info.note)

        # Attempt to update the 'config' submodule.
        pull_config(repo, name)


def main() -> int:
    """Script entry."""

    with Pool() as pool:
        pool.map(repo_fetcher, get_submodules(Path.cwd()))

    return 0


if __name__ == "__main__":
    sys.exit(main())

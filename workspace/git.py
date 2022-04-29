"""
Useful git interactions for workspace repositories.
"""

# built-in
from pathlib import Path
from typing import Callable, Iterator

# third-party
from git import Repo

# internal
from workspace.data import configs

DEFAULT_ORIGIN = "origin"
DEFAULT_MAIN_BRANCH = "master"


def github_ssh_url(user: str, repo: str) -> str:
    """Build an SSH URL for a GitHub repository."""
    return f"git@github.com:{user}/{repo}.git"


def get_submodules(
    start: Path, filter_fn: Callable[[Path], bool] = None
) -> Iterator[Repo]:
    """Find all top-level submodules are contained by a start path."""

    def default_filter(_: Path) -> bool:
        return True

    if filter_fn is None:
        filter_fn = default_filter

    for item in start.iterdir():
        if (
            item.is_dir()
            and item.joinpath(".git").is_file()
            and filter_fn(item)
        ):
            yield Repo(item)


def get_python_submodules(start: Path) -> Iterator[Repo]:
    """Get all submodules that are Python packages."""
    projects = configs()["python"]["packages"]
    return get_submodules(start, lambda x: x.name in projects)


def align_repo(
    repo: Repo,
    remote: str = DEFAULT_ORIGIN,
    main_branch: str = DEFAULT_MAIN_BRANCH,
    name: str = None,
) -> None:
    """
    Perform a few maintenance tasks:
      * checkout a main branch when in a detached HEAD state
      * pull or fetch from the remote, if the remote exists and depending on
        the local state
    """

    if name is None:
        name = Path(str(repo.working_tree_dir)).name

    dirty = repo.is_dirty()
    if dirty:
        print(f"Note: '{name}' has local changes.")
    elif repo.head.is_detached:
        repo.heads[main_branch].checkout()

    fetcher = "fetch" if dirty else "pull"

    if remote in repo.remotes:
        remote = repo.remotes[remote]

        # Pull from the remote.
        print(f"Running '{fetcher}' on '{name}'.")
        for info in getattr(remote, fetcher)():
            if info.note:
                print(info.note)


def pull_config(
    repo: Repo,
    parent: str,
    remote: str = DEFAULT_ORIGIN,
    main_branch: str = DEFAULT_MAIN_BRANCH,
    config_repo: str = "config",
    user: str = "vkottler",
) -> None:
    """
    If a given repository has a 'config' submodule, try and pull the latest.
    """

    config_path = Path(str(repo.working_tree_dir), config_repo)
    if config_path.joinpath(".git").is_file():
        config = Repo(config_path)

        for rem in config.remotes:

            # Update any HTTP[S] remotes.
            if rem.url.startswith("http"):
                print(
                    f"Repository '{parent}' has remote '{rem}' "
                    f"with URL '{rem.url}'."
                )
                rem.set_url(github_ssh_url(user, config_repo))

        align_repo(config, remote, main_branch, f"{config_repo} ({parent})")


def repo_fetcher(
    repo: Repo,
    remote: str = DEFAULT_ORIGIN,
    main_branch: str = DEFAULT_MAIN_BRANCH,
) -> None:
    """Fetch from a given remote for a repository."""

    name = Path(str(repo.working_tree_dir)).name
    align_repo(repo, remote, main_branch, name)

    # Attempt to update the 'config' submodule.
    pull_config(repo, name, remote, main_branch)

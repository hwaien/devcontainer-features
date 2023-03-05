import os
import github
import git
from pprint import pprint


class GitHubContentFile:
    """
    A file in a GitHub repo branch.
    """

    def __init__(self, session: 'GitHubSession', file: github.ContentFile) -> None:
        self.session = session
        self.file = file

    def update(self, message: str, content: str):
        """Commits an update of the file content.

        :param message: string, Required. The commit message.
        :param content: string, Required. The updated file content.
        """
        repo = self.session.repo
        path = self.file.path
        sha = self.file.sha
        branch = self.session.branch
        return repo.update_file(path, message, content, sha, branch)


class GitHubSession:
    """
    A session of interactions with a GitHub repo branch.
    """

    def __init__(self) -> None:
        """
        Opens a session.
        """
        token = os.environ['GITHUB_TOKEN']
        repo_name = os.environ['GITHUB_REPOSITORY']
        self.branch = os.environ['PR_BRANCH']
        self.repo = github.Github(token).get_repo(repo_name)

    def get_file(self, path: str) -> GitHubContentFile:
        """
        Gets the file at a given path.
        """
        dirname = os.path.dirname(path)
        content_list = self.repo.get_contents(dirname, self.branch)
        for content in content_list:
            if (content.path == path):
                return GitHubContentFile(self, content)
        raise FileNotFoundError(errno.ENOENT, os.strerror(errno.ENOENT), path)


def main():
    remote_repo = GitHubSession()
    local_repo = git.Repo('')
    diff_sequence = local_repo.index.diff(None)
    path_sequence = (diff.a_path for diff in diff_sequence)

    for path in path_sequence:
        remote_file = remote_repo.get_file(path)
        with open(path) as local_file:
            content = local_file.read()
        result = remote_file.update(f'Auto-update {path}', content)
        pprint(result)


if __name__ == "__main__":
    main()

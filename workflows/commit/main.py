import os
import github
import git
from pprint import pprint
from typing import Dict, Union

class GitHubContentFile:
    def __init__(self, session: 'GitHubSession', file: github.ContentFile) -> None:
        self.session = session
        self.file = file

    def update(self, message: str, content: str) -> Dict[str, Union[github.ContentFile, github.Commit]]:
        repo = self.session.repo
        path = self.file.path
        sha = self.file.sha
        ref = self.session.ref
        return repo.update_file(path, message, content, sha, ref)

class GitHubSession:
    def __init__(self) -> None:
        token = os.environ['GITHUB_TOKEN']
        repo_name = os.environ['GITHUB_REPOSITORY']
        self.ref = os.environ['PR_BRANCH']
        self.repo = github.Github(token).get_repo(repo_name)

    def get_file(self, path: str) -> GitHubContentFile:
        dirname = os.path.dirname(path)
        content_list = self.repo.get_contents(dirname, self.ref)
        for content in content_list:
            if (content.path == path):
                return GitHubContentFile(self, content)
        raise FileNotFoundError(errno.ENOENT, os.strerror(errno.ENOENT), path)

def main():
    remote_repo = GitHubSession()
    local_repo = git.Repo('')
    diff_sequence = local_repo.index.diff(None)
    path_sequence = (diff.a_path for diff in diff_sequence)

    for path in path_sequence
        remote_file = remote_repo.get_file(path)
        with open(path) as local_file:
            content = local_file.read()
        result = remote_file.update(f'Auto-update {path}', content)
        pprint(result)

if __name__ == "__main__":
    main()

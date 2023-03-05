import os
import github
import git

class GitHubContentFile:
    def __init__(self, session: GitHubSession, file: github.ContentFile) -> None:
        self.session = session
        self.file = file

    def update(self, message: str, content: str) -> None:
        repo = self.session.repo
        path = self.file.path
        sha = self.file.sha
        ref = self.session.ref
        repo.update_file(path, message, content, sha, ref)

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
    diffs = local_repo.index.diff(None)

    for changed_file in diffs:
        path = changed_file.a_path
        remote_file = remote_repo.get_file(path)
        with open(path) as inFile:
            content = inFile.read()
        remote_file.update(f'Auto-update {path}', content)

if __name__ == "__main__":
    main()

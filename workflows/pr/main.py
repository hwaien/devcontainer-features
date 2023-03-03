import os
from github import Github, Repository

def get_contents(repo: Repository, path: str, ref: str):
    for child in repo.get_contents(path, ref):
        if (child.type == 'dir'):
            for descendant in get_contents(repo, child.path, ref):
                yield descendant
        else:
            yield child

def main():
    gh = Github(os.environ['GITHUB_TOKEN'])
    repo = gh.get_repo(os.environ['GITHUB_REPOSITORY'])
    ref = os.environ['GITHUB_REF_NAME']
    for f in get_contents(repo, '', ref):
        print(f.path)
        print(f.type)

if __name__ == "__main__":
    main()
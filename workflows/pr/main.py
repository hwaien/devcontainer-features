import os
import github
import git

def get_contents(repo: github.Repository, path: str, ref: str):
    for child in repo.get_contents(path, ref):
        if (child.type == 'dir'):
            for descendant in get_contents(repo, child.path, ref):
                yield descendant
        else:
            yield child

def get_local_diff_file_paths():
    local_repo = git.Repo('')
    diffs = local_repo.index.diff(None)
    return [d.a_path for d in diffs]

def main():

    diffs = get_local_diff_file_paths()
    for d in diffs:
        print(d)

    gh = github.Github(os.environ['GITHUB_TOKEN'])
    remote_repo = gh.get_repo(os.environ['GITHUB_REPOSITORY'])
    ref = os.environ['GITHUB_REF_NAME']

    for f in get_contents(remote_repo, '', ref):
        print('remote path: ', f.path)
        print('remote sha: ', f.sha)

if __name__ == "__main__":
    main()
import os
import hashlib
import github
import git

def get_contents(repo: github.Repository, path: str, ref: str):
    for child in repo.get_contents(path, ref):
        if (child.type == 'dir'):
            for descendant in get_contents(repo, child.path, ref):
                yield descendant
        else:
            yield child

def main():
    gh = github.Github(os.environ['GITHUB_TOKEN'])
    remote_repo = gh.get_repo(os.environ['GITHUB_REPOSITORY'])
    ref = os.environ['GITHUB_REF_NAME']

    for f in get_contents(remote_repo, '', ref):
        print('remote path: ', f.path)
        print('remote sha: ', f.sha)
        print('local sha: ', hashlib.sha256(open(f.path,'rb').read()).hexdigest())

    local_repo = git.Repo('')
    print ("local repo common git dir: ", local_repo.common_dir)
    print ('LOCAL DIFF')
    for d in local_repo.index.diff():
        print(d)


if __name__ == "__main__":
    main()
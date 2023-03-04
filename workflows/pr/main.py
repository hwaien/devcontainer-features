import os
import github
import git

def main():
    gh = github.Github(os.environ['GITHUB_TOKEN'])
    remote_repo = gh.get_repo(os.environ['GITHUB_REPOSITORY'])
    ref = os.environ['PR_BRANCH']

    local_repo = git.Repo('')
    diffs = local_repo.index.diff(None)

    updated = False

    for d in diffs:
        path = d.a_path
        dirname = os.path.dirname(path)
        remote_contents = remote_repo.get_contents(dirname, ref)
        for c in remote_contents:
            if (c.path == path):
                with open(path) as inFile:
                    content = inFile.read() 
                remote_repo.update_file(path, f'Auto-update {path}', content, c.sha, ref)
                updated = True
                break

    return 0 if updated else 1

if __name__ == "__main__":
    code = main()
    sys.exit(code)

import os
from github import Github

def main():
    gh = Github(os.environ['GITHUB_TOKEN'])
    repo = gh.get_repo(os.environ['GITHUB_REPOSITORY'])
    branch = os.environ['GITHUB_REF_NAME']
    files = repo.get_contents('', branch)
    for f in files:
        print(f.path)
        print(f.type)

if __name__ == "__main__":
    main()
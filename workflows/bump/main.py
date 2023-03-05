from glob import glob
import json
from semver import VersionInfo

def bump(path: str):
    with open(path) as inFile:
        fileContent = json.load(inFile)
    originalVersionString = fileContent['version']
    originalVersion = VersionInfo.parse(originalVersionString)
    bumpedVersion = originalVersion.bump_patch()
    bumpedVersionString = str(bumpedVersion)
    fileContent['version'] = bumpedVersionString
    print(path)
    print(fileContent)
    with open(path, 'w') as outFile:
        json.dump(fileContent, outFile, indent=2)

def main():
    for metadata in glob('src/*/devcontainer-feature.json'):
        bump(metadata)

if __name__ == "__main__":
    main()

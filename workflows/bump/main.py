from glob import glob
import json
from pprint import pprint
from semver import VersionInfo

def bump_patch(version: str) -> str:
    """Given a SemVer string, bump its patch part and return the result."""
    parsed = VersionInfo.parse(version)
    bumped = parsed.bump_patch()
    return str(bumped)

def update(path: str) -> None:
    """Load a Dev Container Feature metadata file, bump the patch part of its version, and save it."""
    print(path)
    with open(path) as inFile:
        data = json.load(inFile)
    data['version'] = bump_patch(data['version'])
    pprint(data)
    with open(path, 'w') as outFile:
        json.dump(data, outFile, indent=2)

def main() -> None:
    for metadata in glob('src/*/devcontainer-feature.json'):
        update(metadata)

if __name__ == "__main__":
    main()

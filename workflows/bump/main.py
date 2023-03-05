from glob import glob
import json
from pprint import pprint
from semver import VersionInfo


def bump_patch(version: str) -> str:
    """
    Given a SemVer string, bumps its patch part and returns the result.
    """

    parsed = VersionInfo.parse(version)
    bumped = parsed.bump_patch()
    return str(bumped)


def update(path: str) -> None:
    """
    Loads a Dev Container Feature metadata file, bumps the patch part of its version, and saves it.
    """

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

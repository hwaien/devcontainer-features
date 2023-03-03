# Dev Container Features

This repository contains a collection of [dev container Features](https://containers.dev/implementors/features/), hosted on the GitHub Container Registry. The Features in this repository follow the [dev container Feature distribution specification](https://containers.dev/implementors/features-distribution/).

## Contents

This repository contains a _collection_ of Feature implementations. Each sub-section below shows a sample `devcontainer.json` usage.

### `match-host-time-zone`

The built container will match the host's time zone.

```jsonc
{
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
  "features": {
    "ghcr.io/hwaien/devcontainer-features/match-host-time-zone": {}
  }
}
```

## Repo Structure

Similar to the [`devcontainers/features`](https://github.com/devcontainers/features) repo, this repository has a `src` folder. Each Feature has its own sub-folder, containing at least a `devcontainer-feature.json` and an entrypoint script `install.sh`.

```
├── src
│   ├── match-host-time-zone
│   │   ├── devcontainer-feature.json
│   │   └── install.sh
|   ├── ...
│   │   ├── devcontainer-feature.json
│   │   └── install.sh
...
```

An [implementing tool](https://containers.dev/supporting#tools) will composite [the documented dev container properties](https://containers.dev/implementors/features/#devcontainer-feature-json-properties) from the feature's `devcontainer-feature.json` file, and execute in the `install.sh` entrypoint script in the container during build time. Implementing tools are also free to process attributes under the `customizations` property as desired.

## Distributing Features

### Versioning

Features are individually versioned by the `version` attribute in a Feature's `devcontainer-feature.json`. Features are versioned according to the semver specification. More details can be found in [the dev container Feature specification](https://containers.dev/implementors/features/#versioning).

### Publishing

This repo contains a GitHub Action [workflow](.github/workflows/release.yaml) that will publish each feature to GHCR. By default, each Feature will be prefixed with the `<owner>/<repo>` namespace. For example, the `match-host-time-zone` Feature in this repository can be referenced in a `devcontainer.json` with:

```
ghcr.io/hwaien/devcontainer-features/match-host-time-zone:1
```

The provided GitHub Action will also publish a third "metadata" package with just the namespace, eg: `ghcr.io/hwaien/devcontainer-features`. This contains information useful for tools aiding in Feature discovery.

'`hwaien/devcontainer-features`' is known as the feature collection namespace.

### Marking Feature Public

Note that by default, GHCR packages are marked as `private`. To stay within the free tier, Features need to be marked as `public`.

This can be done by navigating to the Feature's "package settings" page in GHCR, and setting the visibility to 'public`.

### Adding Features to the Index

For Features to appear in the [public index](https://containers.dev/features) so that other community members can find them, you can do the following:

- Go to [github.com/devcontainers/devcontainers.github.io](https://github.com/devcontainers/devcontainers.github.io)
  - This is the GitHub repo backing the [containers.dev](https://containers.dev/) spec site
- Open a PR to modify the [collection-index.yml](https://github.com/devcontainers/devcontainers.github.io/blob/gh-pages/_data/collection-index.yml) file

This index is from where [supporting tools](https://containers.dev/supporting) like [VS Code Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) and [GitHub Codespaces](https://github.com/features/codespaces) surface Features for their dev container creation UI.

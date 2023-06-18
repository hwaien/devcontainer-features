#!/usr/bin/env bash

set -e

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

if ! type npm > /dev/null 2>&1; then
    echo "Hyas CLI installation skipped because npm is missing."
    exit 1
fi

npm install -g @hyas/cli@"$VERSION"

echo "Hyas CLI successfully installed."
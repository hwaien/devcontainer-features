#!/usr/bin/env bash

set -e

rm -rf /var/lib/apt/lists/*

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

echo "Checking if package is already installed..."
if ! dpkg -s git-remote-gcrypt > /dev/null 2>&1; then
    if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
        echo "Updating apt-get..."
        apt-get update -y
    fi
   echo "Installing package..."
    apt-get -y install --no-install-recommends git-remote-gcrypt
fi
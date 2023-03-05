#!/bin/bash

# This test file will be executed against an auto-generated devcontainer.json that
# includes the Feature with options defined in the scenarios.json file.
#
# For more information, see: https://github.com/devcontainers/cli/blob/main/docs/features/test.md

set -e

# Import test library bundled with the devcontainer CLI
# Provides the 'check' and 'reportResults' commands.
source dev-container-features-test-lib

# Feature-specific tests
# The 'check' command comes from the dev-container-features-test-lib.
check "custom-passphrase-used" ssh-keygen -y -N "phrase1" -f ~/.ssh/id_rsa

# Report results
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
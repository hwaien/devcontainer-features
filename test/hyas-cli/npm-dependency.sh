#!/bin/bash

# This test file will be executed against an auto-generated devcontainer.json that
# includes the Feature with no options.
#
# For more information, see: https://github.com/devcontainers/cli/blob/main/docs/features/test.md
#
# The value of all options will fall back to the default value in 
# the Feature's 'devcontainer-feature.json'.
#
# These scripts are run as 'root' by default. Although that can be changed
# with the '--remote-user' flag.

set -e

# Import test library bundled with the devcontainer CLI
# Provides the 'check' and 'reportResults' commands.
source dev-container-features-test-lib

# Feature-specific tests
# The 'check' command comes from the dev-container-features-test-lib.
check "installation-skipped-if-npm-missing" ! npm list -g | grep "@hyas/cli"

# Report results
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
#!/bin/sh
set -e

apt_get_update()
{
    if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
        echo "Running apt-get update..."
        apt-get update -y
    fi
}

check_apt_packages() {
    if ! dpkg -s "$@" > /dev/null 2>&1; then
        apt_get_update
        apt-get -y install --no-install-recommends "$@"
    fi
}

check_packages() {
    check_apt_packages $@
}

echo "Generating SSH key"

SSHKEYPASSPHRASE=${SSHKEYPASSPHRASE:-""}
SSHKEYPATH=${SSHKEYPATH:-"$_REMOTE_USER_HOME/.ssh/id_rsa"}
SSHKEYDIR=${SSHKEYPATH%/*}

mkdir -p $SSHKEYDIR

if [[ type apt-get  ]]
check_packages ssh ssh ssh

ssh-keygen -t rsa -N "$SSHKEYPASSPHRASE" -f "$SSHKEYPATH"

chown -R $_REMOTE_USER $SSHKEYDIR

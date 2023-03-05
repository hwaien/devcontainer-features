#!/bin/sh
set -e

apt_get_update()
{
    if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
        echo "Running apt-get update..."
        apt-get update -y
    fi
}

check_packages() {
    if ! dpkg -s "$@" > /dev/null 2>&1; then
        apt_get_update
        apt-get -y install --no-install-recommends "$@"
    fi
}

echo "Generating SSH key"

SSHKEYPASSPHRASE=${SSHKEYPASSPHRASE:-"foo"}
echo "The provided passphrase is: $SSHKEYPASSPHRASE"

SSHKEYPATH=${SSHKEYPATH:-"/home/root/.ssh/default/id_rsa"}
echo "The provided path is: $SSHKEYPATH"

if [ -z "$SSHKEYPATH" ];
    SSHKEYPATH = $_REMOTE_USER_HOME/.ssh/id_rsa
fi

mkdir -p ${SSHKEYPATH%/*}

check_packages ssh

ssh-keygen -t rsa -N '$SSHKEYPASSPHRASE' -f $SSHKEYPATH

chown -R ${SSHKEYPATH%/*}

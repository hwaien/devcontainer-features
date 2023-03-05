#!/bin/sh
set -e

apt_get_update()
{
    if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
        echo "Running apt-get update..."
        apt-get update -y
    fi
}

install_ssh() {
    type ssh-keygen
    status=$?
    if [ $status -ne 0 ]
    then
        type apt-get
        status=$?
        if [ $status -eq 0 ]
        then
            apt_get_update
            apt-get -y install --no-install-recommends ssh
        else
            type apk
            status=$?
            if [ $status -eq 0 ]
            then
                apk add ssh
            else
                echo "no package manager"
            fi
        fi
    fi
}

echo "Generating SSH key"

SSHKEYPASSPHRASE=${SSHKEYPASSPHRASE:-""}
SSHKEYPATH=${SSHKEYPATH:-"$_REMOTE_USER_HOME/.ssh/id_rsa"}
SSHKEYDIR=${SSHKEYPATH%/*}

mkdir -p $SSHKEYDIR

install_ssh

ssh-keygen -t rsa -N "$SSHKEYPASSPHRASE" -f "$SSHKEYPATH"

chown -R $_REMOTE_USER $SSHKEYDIR

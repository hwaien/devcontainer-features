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
    echo "asdfasdfasdf"
    type ssh-keygen || missing=true
    echo "asdfasdfasdf 3"
    if [ $missing = true ]
    then
        echo "ssh-keygen does not exist in image."
        type apt-get || missing=true
        if [ $missing = true ]
        then
            echo "apt-get does not exist in image."
            type apk || missing=true
            if [ $missing = true ]
            then
                echo "no package manager"
            else
                echo "apk exists in image."
                apk add ssh
            fi
        else
            echo "apt-get exists in image."
            apt_get_update
            apt-get -y install --no-install-recommends ssh
        fi
    else
        echo "ssh-keygen exists in image."
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

#!/bin/sh
set -e

install_ssh() {
    type ssh-keygen || keygenmissing=true
    if [ $keygenmissing = true ]
    then
        echo "ssh-keygen does not exist in image."
        type apt-get || aptgetmissing=true
        if [ $aptgetmissing = true ]
        then
            echo "apt-get does not exist in image."
            type apk || apkmissing=true
            if [ $apkmissing = true ]
            then
                echo "no package manager"
            else
                echo "apk exists in image."
                apk add ssh
            fi
        else
            echo "apt-get exists in image."
            apt-get update -y
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

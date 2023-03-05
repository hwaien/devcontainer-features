#!/bin/sh
set -e

apt_get_update_if_needed()
{
    export DEBIAN_FRONTEND=noninteractive
    if [ ! -d "/var/lib/apt/lists" ] || [ "$(ls /var/lib/apt/lists/ | wc -l)" = "0" ]; then
        echo "Running apt-get update..."
        apt-get update
    else
        echo "Skipping apt-get update."
    fi
}

install_packages() {
    if type apt-get > /dev/null 2>&1; then
        apt_get_update_if_needed
        apt-get -y install --no-install-recommends $1
    elif type apk > /dev/null 2>&1; then
        apk add $2
    elif type dnf > /dev/null 2>&1; then
        dnf install -y $3
    elif type yum > /dev/null 2>&1; then
        yum install -y $3
    else
        echo "Unable to find package manager to install ${command_to_check}"
        exit 1
    fi
}

check_packages() {
    if type dpkg > /dev/null 2>&1 && dpkg -s $1 > /dev/null 2>&1; then
        return 0
    elif type apk > /dev/null 2>&1 && apk -e info $2 > /dev/null 2>&1; then
        return 0
    elif type rpm > /dev/null 2>&1 && rpm -q $3 > /dev/null 2>&1; then
        return 0
    else
        echo "Unable to find package manager to check for packages."
        exit 1
    fi
    install_packages "$@"
    return $?
}

echo "Generating SSH key"

SSHKEYPASSPHRASE=${SSHKEYPASSPHRASE:-""}
SSHKEYPATH=${SSHKEYPATH:-"$_REMOTE_USER_HOME/.ssh/id_rsa"}
SSHKEYDIR=${SSHKEYPATH%/*}

mkdir -p $SSHKEYDIR

check_packages ssh ssh ssh

ssh-keygen -t rsa -N "$SSHKEYPASSPHRASE" -f "$SSHKEYPATH"

chown -R $_REMOTE_USER $SSHKEYDIR

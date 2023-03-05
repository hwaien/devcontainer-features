#!/bin/sh

echo "Generating SSH key"

apt_get_update()
{
    if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
        echo "Running apt-get update..."
        apt-get update -y
        echo "/etc/apt/sources.list"
        cat /etc/apt/sources.list
        echo "ls /etc/apt/sources.list.d"
        ls /etc/apt/sources.list.d
    fi
}

check_packages() {
    if ! dpkg -s "$@" > /dev/null 2>&1; then
        apt_get_update
        apt-get -y install --no-install-recommends "$@"
    fi
}

echo $_REMOTE_USER_HOME

mkdir -p $_REMOTE_USER_HOME/.ssh/

check_packages openssh-clients

ssh-keygen -t rsa -N '' -f $_REMOTE_USER_HOME/.ssh/id_rsa

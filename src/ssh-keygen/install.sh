#!/bin/sh

echo "Generating SSH key"

echo $_REMOTE_USER_HOME

mkdir -p $_REMOTE_USER_HOME/.ssh/

ssh-keygen -t rsa -N '' -f $_REMOTE_USER_HOME/.ssh/id_rsa

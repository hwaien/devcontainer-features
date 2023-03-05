#!/bin/sh

echo "Generating SSH key"

echo $_REMOTE_USER_HOME

echo $_REMOTE_USER_HOME/.ssh/id_rsa

ssh-keygen -t rsa -N '' -f $_REMOTE_USER_HOME/.ssh/id_rsa

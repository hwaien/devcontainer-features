#!/bin/sh

echo "Generating SSH key"

ssh-keygen -t rsa -N '' -f $_REMOTE_USER_HOME/.ssh/id_rsa

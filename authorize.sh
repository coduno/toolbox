#!/bin/bash
#
# Author: Lorenz Leutgeb <lorenz.leutgeb@cod.uno>
#
# Usage: ./authorize.sh <user-name>
# Script to add the public key of a GitHub user to the
# list of authorized keys for git on this server

DEFAULT_CONFIG_FILE=config.rc

# $CONFIG_FILE should point at the config file created by setup.sh
if [ -z $CONFIG_FILE ]; then
	CONFIG_FILE=$DEFAULT_CONFIG_FILE
fi

eval $(cat config.rc)

# User needs a name
if [ -z $1 ]; then
	echo "User must have a non-empty name"
	exit 1
fi

USER_NAME=$1

curl "https://api.github.com/users/$USER_NAME/keys" | grep key | tr -d '"' | cut -d' ' -f6- \
| while read key
do
	echo "$key $USER_NAME" | tee -a $GIT_HOME/.ssh/authorized_keys
done
#!/bin/bash

# Enter the base name of the proxy servers.
echo -n "Your proxy server names will all begin with base name. Enter a base name: "
read BASE_NAME
# Enter the total number of proxy servers you want to create.
echo -n "Enter the total number of proxy servers you want to create: "
read TOTAL
# Enter the script name you wish to run.
echo -n "Enter the script name you wish to run: "
read SCRIPT_NAME
# Enter the root password of the new proxy servers.
echo -n "Password: "
read -s PASSWORD

echo
echo "Starting..."


# Ex: BASE_NAME = "Test", TOTAL = "3", SCRIPT_NAME = "FOO", PASSWORD = "FUCKTHUAN"
# The above settings will create three servers
# with the names: Test1, Test2, Test3
# Each server will be initialized with the script "FOO".
# Each server will have the root ssh password "FUCKTHUAN".

COUNTER=0

while [ $COUNTER -lt $TOTAL ]; do
    linode create $BASE_NAME$COUNTER --stackscript "${SCRIPT_NAME}" --stackscriptjson "{ }" --password "$PASSWORD"
    let COUNTER=COUNTER+1
done

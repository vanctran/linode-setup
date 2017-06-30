#!/bin/bash

if [ $# -eq 0 ]
then
    echo "No argument provided. Please enter either create or delete."
    exit 1
elif [ $1 == 'create' ]
then
    # Enter the base name of the proxy servers.
    # echo -n "Your proxy server names will all begin with base name. Enter a base name: "
    # read BASE_NAME
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
        linode create "proxygen"$COUNTER --stackscript "${SCRIPT_NAME}" --stackscriptjson "{ }" --password "$PASSWORD" &
        let COUNTER=COUNTER+1
    done
elif [ $1 == 'delete' ]
then
    # Enter the amount of proxy servers to delete.
    echo -n "Enter the amount of proxygen servers to delete: "
    read TOTAL
    echo "Deleting Proxygen servers..."

    COUNTER=0

    while [ $COUNTER -lt $TOTAL ]; do
        linode-linode delete "proxygen"$COUNTER &
        let COUNTER=COUNTER+1
    done
elif [ $1 == 'ip' ]
then
    echo -n "Enter the number of Proxygen servers: "
    read TOTAL
    echo -n "Enter your proxy port: "
    read PORT
    echo "Generating IP list..."

    COUNTER=0
    PREFIX="ips:"

    while [ $COUNTER -lt $TOTAL ]; do
        OUTPUT=$(linode show "proxygen"$COUNTER | tail -2 | head -1)
        echo "${OUTPUT/$PREFIX/}:$PORT" | tr -d ' ' >> "./ip_list.txt"
        let COUNTER=$COUNTER+1
    done
    echo
else
    echo "Invalid argument. Please enter either create or delete."
fi


#!/bin/bash

CONFIG_READY=false
NAME_PREFIX="proxygen"
STACKSCRIPT_NAME=""
PASSWORD=""

# Parameters (name prefix, port, min range, max range, filename)
retrieve_ip (){
    local counter=$3
    local name_prefix=$1
    local prefix="ips:"
    local max=$4
    ((max++))
    local file_name=$5 

    while [ $counter -lt $max ];
    do
        output=$(linode show $name_prefix$counter | tail -2 | head -1)
        echo "${output/$prefix/}:$port" | tr -d ' ' >> "./$file_name"
        let counter=$counter+1
    done
    echo
}

create (){
    # Ex: NAME_PREFIX = "Test", total = "3", STACKSCRIPT_NAME = "FOO", PASSWORD = "BAR"
    # The above settings will create three servers
    # with the names: Test1, Test2, Test3
    # Each server will be initialized with the script "FOO".
    # Each server will have the root ssh password "BAR".

    local id=$1
    local total=$2
    local counter=0

    while [ $counter -lt $total ];
    do
        linode create $NAME_PREFIX$id --stackscript "${STACKSCRIPT_NAME}" --stackscriptjson "{ }" --password "$PASSWORD" &
        let counter=counter+1
        let id=id+1
    done
    wait
}

delete (){
    local counter=$2
    local max=$3
    ((max++))
    while [ $counter -lt $max ];
    do
        linode-linode delete $1$counter &
        let counter=counter+1
    done
    wait
}

menu (){
    local option=0
    
    while true
    do
        tput bold
        echo "Proxygen Menu"
        echo "1. Setup your node configurations"
        echo "2. Display your current node configurations"
        echo "3. Retrieve IP list"
        echo "4. Create nodes"
        echo "5. Delete nodes"
        echo "6. Exit"
        echo -n "Enter a number corresponding to the menu option to begin (1-6): "

        while [ $option -eq 0 ];
        do
            read option
            if [ $option -lt 1 ] || [ $option -gt 6 ]
            then
                echo -n "Invalid option selected. Please enter a a valid number (1-6): "
                option=0
            fi
        done
        tput sgr0
        
        tput clear
        if [ $option -eq 1 ] # Setup node config
        then
            echo
            echo "Please choose a prefix name to prepend to the front of the new proxy nodes so that Proxygen can manage them. The default prefix name is proxygen."
            echo "Example - When creating 3 servers with the prefix name "Test", the nodes will be named Test1, Test2, and Test3."
            echo
            tput bold
            echo -n "Enter the prefix to use in the name of the new proxy nodes: "
            read NAME_PREFIX
            echo -n "Enter the name of the stackscript you wish to run after server creation: "
            read STACKSCRIPT_NAME
            # Enter the root password of the new proxy servers.
            echo -n "Enter the root password for the new proxy servers: "
            read -s PASSWORD
            tput sgr0
            CONFIG_READY=true
        elif [ $option -eq 2 ] # Display current node config
        then
            tput bold
            echo "Current node configuration"
            echo "Name Prefix: $NAME_PREFIX"
            echo "Stackscript: $STACKSCRIPT_NAME"
            tput sgr0
        elif [ $option -eq 3 ] # Generate IP list
        then
            # Parameters (name prefix, port, min range, max range, filename)
            tput bold
            echo -n "Please enter the prefix name of the nodes to retrieve: "
            read prefix_name
            echo -n "Please enter the port used for the node proxy: "
            read port
            echo -n "Please enter the min number in the node IDs: "
            read min_num
            echo -n "Please enter the max number in the node IDs: "
            read max_num
            echo -n "Please enter the filename to save the IPs to: "
            read file_name
            tput sgr0
            retrieve_ip $prefix_name $port $min_num $max_num $file_name
        elif [ $option -eq 4 ] # Create nodes
        then
            if [ $CONFIG_READY ]
            then
                tput bold
                echo -n "Please enter the starting number for the node IDs: "
                read min_num
                echo -n "Please enter the total number of nodes to create: "
                read max_num
                tput sgr0
                create $min_num $max_num

            else
                echo "Please setup the node configurations before creating nodes."
            fi
        elif [ $option -eq 5 ] # Delete nodes
        then
            echo
            echo "The prefix name for the node(s) to be deleted is required along with the range of nodes to be deleted."
            echo "Example - When provided with the prefix name "Test" and a min range of 1 and max range of 3, proxy nodes Test1, Test2, and Test3 will be deleted."
            echo
            tput bold
            echo -n "Please enter the prefix name of the nodes you wish to delete: "
            read prefix_name
            echo -n "Please enter the min number in the range of deletion: "
            read min_num
            echo -n "Please enter the max number in the range of deletion: "
            read max_num
            echo "Preparing to delete nodes $prefix_name[$min_num...$max_num]"
            tput sgr0
            delete $prefix_name $min_num $max_num
        elif [ $option -eq 6 ] # Exit
        then
            echo "Exiting Proxygen..."
            exit 0
        fi
        option=0
        echo
    done
}

if [ $# -eq 0 ]
then
    tput bold
    echo "Welcome to Proxygen"
    tput sgr0
    menu
    exit 1
elif [ $1 == 'create' ]
then
    echo "Command line create not yet implemented."
elif [ $1 == 'delete' ]
then
    # Enter the amount of proxy servers to delete.
    echo "Deleting Proxygen server $2"
    linode-linode delete $2 &
elif [ $1 == 'ip' ]
then
    echo "Command line IP retrieval not yet implemented."
else
    echo "Invalid argument. Please enter either create or delete."
fi


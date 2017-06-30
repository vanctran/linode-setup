#!/bin/bash

sudo bash -c 'echo "deb http://apt.linode.com/ $(lsb_release -cs) main" > /etc/apt/sources.list.d/linode.list'
wget -O- https://apt.linode.com/linode.gpg | sudo apt-key add -
sudo apt-get update
sudo apt-get install linode-cli -y
linode configure

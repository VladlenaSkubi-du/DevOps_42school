#!/bin/bash

sudo yum update -y

ifconfig=$(which ifconfig)
if [ -z "$ifconfig" ]
then
    sudo yum install net-tools -y # download ifconfig
fi



#!/bin/bash

name=$1

if [ -z "$name" ]
then
    echo "Please, enter virtual machine name as argument"
    exit 1
fi

vagrant halt $name
yes | vagrant destroy $name
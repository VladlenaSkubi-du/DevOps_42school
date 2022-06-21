#!/bin/bash

ifconfig=$(which ifconfig)
if [ -z "$ifconfig" ]
then
    echo no ifconfig command found
fi

k3s=$(which k3s)
if [ -z "$k3s" ]
then
    echo no k3s command found
fi
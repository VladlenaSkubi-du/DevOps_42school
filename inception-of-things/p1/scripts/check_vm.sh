#!/bin/bash

echo "VM is connected to private network as an internal network for VirtualBox with address inet 192.168.42.110"
ifconfig eth1

echo "Checking nodes of k3s"
k get nodes -o wide
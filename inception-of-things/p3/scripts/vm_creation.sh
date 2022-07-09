#!/bin/bash

VM='p3_fullcd_sschmele'

# Create and Register the VM with VirtualBox
VBoxManage createvm --name $VM \
    --ostype Ubuntu_64 \
    --basefolder "$HOME/VirtualBox\ VMs" \
    --register

# Create hard disk
VBoxManage createhd \
    --filename "$HOME/VirtualBox\ VMs/$VM/$VM.vdi" \
    --format VDI \
    --size 10000

# Attach the hard drive to the VM
VBoxManage storagectl $VM \
    --add sata \
    --name "SATA"

VBoxManage storageattach $VM \
    --storagectl "SATA" \
    --port 0 \
    --device 0 \
    --type hdd \
    --medium "$HOME/VirtualBox\ VMs/$VM/$VM.vdi"

# Attach the bootable ISO to the VM
VBoxManage storagectl $VM \
    --add ide \
    --name "IDE"

VBoxManage storageattach $VM \
    --storagectl "IDE" \
    --port 0 \
    --device 0 \
    --type dvddrive \
    --medium "$HOME/school_21/ubuntu-20.04.4-live-server-amd64.iso"

# Configure the settings for the VM
VBoxManage modifyvm $VM --memory 1024 --cpus 1
VBoxManage modifyvm $VM --nic1 nat --cableconnected1 on
VBoxManage modifyvm $VM --nic2 hostonly --cableconnected1 on --hostonlyadapter2 vboxnet0


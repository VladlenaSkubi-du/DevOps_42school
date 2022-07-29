#!/bin/bash

VM='p3_sschmele_fullcd'

# Create and Register the VM with VirtualBox
VBoxManage createvm --name $VM \
    --ostype RedHat_64 \
    --basefolder "$HOME/VirtualBox VMs" \
    --register

# Configure the settings for the VM
VBoxManage modifyvm $VM --memory 2048 --cpus 2
VBoxManage modifyvm $VM --nic1 nat --cableconnected1 on
VBoxManage modifyvm $VM --nic2 hostonly --cableconnected1 on --hostonlyadapter2 vboxnet0
VBoxManage modifyvm $VM --boot1 dvd # Boot devices

# Create hard disk
VBoxManage createhd \
    --filename "$HOME/VirtualBox VMs/$VM/$VM.vdi" \
    --format VDI \
    --size 20480 \
    --variant Standard

# Attach the hard drive to the VM
VBoxManage storagectl $VM \
    --add sata \
    --name "$VM-SATA"

VBoxManage storageattach $VM \
    --storagectl "$VM-SATA" \
    --port 1 \
    --type hdd \
    --medium "$HOME/VirtualBox VMs/$VM/$VM.vdi"

# Attach the bootable ISO to the VM
VBoxManage storageattach $VM \
    --storagectl "$VM-SATA" \
    --port 0 \
    --type dvddrive \
    --medium "$HOME/school_21/CentOS-7-x86_64-Minimal-2009.iso"

# Adding sharedfolder
VBoxManage sharedfolder add $VM \
    --name="p3" \
    --hostpath="/Users/a18979859/school_21/DevOps_42school/inception-of-things/p3" \
    --auto-mount-point="/tmp/confs" \
    --automount

# Show VM information
VBoxManage showvminfo $VM

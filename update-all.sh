#! /bin/bash

if [ $2 = 'y' ]; then
    cp "$1/resolv.conf" /etc/resolv.conf
fi
apt update
apt upgrade -y
apt autoremove -y

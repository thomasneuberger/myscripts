#! /bin/bash

cp "$1/resolv.conf" /etc/resolv.conf
apt update
apt upgrade -y
apt autoremove -y

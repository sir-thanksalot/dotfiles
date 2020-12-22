#!/usr/bin/env bash

# Update apt
apt update -y

# Upgrade any preinstalled packages
apt upgrade -y

# Git, obviously
apt install git -y
# Vim
apt install vim -y
#cURL
apt install curl -y
#htop
apt install htop -y

# Cleanup
apt clean
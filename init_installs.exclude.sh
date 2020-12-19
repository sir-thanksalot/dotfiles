#!/usr/bin/env bash
PROMPT='[apt-install]'

echo "$PROMPT I hope you trust me enough to run me as root! :)"

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



# Cleanup
apt clean
#!/usr/bin/env bash

#install git and clone this repo, then move it to .setitup
if [ ! -d ./.dotfiles ] ; then
    apt install git -y
    git clone https://github.com/sir-thanksalot/dotfiles.git
    mv ./dotfiles ./.dotfiles
    echo "Next Step:"
    echo "sudo .setitup/bootstrap.exclude.sh"
else 
    echo "Already Installed!"
fi

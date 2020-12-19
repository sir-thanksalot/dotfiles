#!/usr/bin/env bash

#install git and clone this repo, then move it to .setitup
if [ ! ./.setitup ] ; then
    apt install git -y
    git clone https://github.com/sir-thanksalot/setitup.git
    mv ./setitup ./.setitup
    echo "Next Step:"
    echo "sudo .setitup/bootstrap.exclude.sh"
else 
    echo "Already Installed!"
fi

#!/usr/bin/env bash

#check if git is installed. if yes, clone this repo and rename dir to .setitup
git --version 2>&1 >/dev/null 
GIT_IS_AVAILABLE=$?
if [ ! $GIT_IS_AVAILABLE -eq 0 ]; then 
    echo "Install git first!"
elif [ ! -d ./.dotfiles ] ; then
    git clone https://github.com/sir-thanksalot/dotfiles.git
    mv ./dotfiles ./.dotfiles
    echo "Next Step:"
    echo "sudo .dotfiles/bootstrap.exclude.sh"
else 
    echo "Already Installed!"
fi

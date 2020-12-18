#!/usr/bin/env bash

apt install git -y
git clone https://github.com/sir-thanksalot/setitup.git
mv ./setitup ./.setitup
echo "Next Steps: execute .setitup/bootstrap.exclude.sh"
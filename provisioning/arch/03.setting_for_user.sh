#!/bin/bash
#
# curl -o 03.sh https://raw.githubusercontent.com/tontoroRR/myenvs/main/provisioning/arch/03.setting_for_user.sh

# Generate key for ssh with PSA
ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa.arch <<<y
cat ~/.ssh/id_rsa.arch.pub >> ~/.ssh/authorized_keys
chmod 700 ~/.ssh
chmod 600 ~/.ssh/*
more ~/.ssh/id_rsa.arch

exit
# shotdown -h now

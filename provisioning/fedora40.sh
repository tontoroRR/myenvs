#!/bin/bash

sudo dnf update -y
sudo dnf install -y kernel-devel make gcc bzip2 perl
sudo reboot

sudo /run/media/$USER/VBox_GA_xxxx/VBoxLinuxAdditions.run

sudo usermod -aG vboxsf $USER

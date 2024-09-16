#!/bin/bash
# Run this script from root
#
# curl -o 11.sh https://raw.githubusercontent.com/tontoroRR/myenvs/main/provisioning/arch/11.setup_root.sh

USERNAME=tontoro # non-root user

# Enable Japan server in mirror list
# sed -i -e "s/^Server/#Server/" /etc/pacman.d/mirrorlist
# sed -i -e "s/#\(Server.*jaist.*\)/\1/" /etc/pacman.d/mirrorlist

# Reset key and update package
pacman-key --init
pacman-key --populate archlinux
pacman -Syy --noconfirm archlinux-keyring
pacman -Syu --noconfirm

# Install guest addition
pacman -S --noconfirm virtualbox-guest-utils
systemctl enable --now vboxservice

# Install apps
pacman -S --noconfirm base-devel git wget neovim unzip libyaml
pacman -S --noconfirm ripgrep fd fzf
# pacman -S --noconfirm zoxide ripgrep fd fzf

# Add user to vboxsf group
usermod -aG vboxsf $USERNAME

#!/bin/bash
# Run this script from root
# Enable Japan server in mirror list
sed -i -e "s/^Server/#Server/" /etc/pacman.d/mirrorlist
sed -i -e "s/#\(Server.*jaist.*\)/\1/" /etc/pacman.d/mirrorlist

# Reset key and update package
pacman-key --init
pacman-key --populate archlinux
pacman -Syy --noconfirm archlinux-keyring
pacman -Syu --noconfirm

# add default user in wheel group 
USERNAME=tontoro
PASSWORD=pass
useradd --create-home $USERNAME
echo "$USERNAME:$PASSWORD" | chpasswd
usermod -aG wheel $USERNAME

# Allow sudo for wheel members
pacman -S --noconfirm vi sudo
sed -i -e "s/# \(.*%wheel.*\)/\1/" /etc/sudoers

# Change default user
sed -i -e "s/root/$USERNAME"
echo -e "\n[user]\ndefault=$USERNAME" >> /etc/wsl.conf

# Install apps
pacman -S --noconfirm base-devel git wget neovim unzip libyaml
pacman -S --noconfirm zoxide ripgrep fd fzf

# Switch user
su $USERNAME

# asdf
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.1
echo . "\$HOME/.asdf/asdf.sh" >> ~/.bashrc
echo . "\$HOME/.asdf/completions/asdf.bash" >> ~/.bashrc
. ~/.bashrc

# install languages by asdf
asdf plugin add nodejs
asdf install nodejs latest
asdf global nodejs latest
asdf plugin add python
asdf install python latest
asdf global python latest
asdf plugin add lua
asdf install lua 5.1
asdf global lua 5.1
asdf plugin add ruby
asdf install ruby latest
asdf global ruby latest

# libraries
npm install -g neovim
npm install -g yarn
npm install -g tree-sitter-cli
gem install neovim
pip install --user --upgrade pynvim

# Setup for rust tools
echo eval "\"\$(zoxide init bash)\"" >> ~/.bashrc
echo "[ -f ~/.fzf.bash ] && source ~/.fzf.bash" >> ~/.bashrc

# neovim
mkdir -p ~/.config/nvim
wget -O ~/.config/nvim/init.lua https://raw.githubusercontent.com/tontoroRR/myenvs/main/init.lua 

# docker
sudo pacman -S --noconfirm docker
sudo usermod -aG docker $USER
sudo systemctl enable --now docker.service
sudo systemctl enable --now containerd.service

# GUI
sudo pacman -S --noconfirm xorg-server
sudo pacman -S xorg-apps
sudo pacman -S xorg-xclock; xclock
## ↑ If 'cant open DISPLAY ~~' happens, exit from wsl.
## Then, run "wsl --shutdown; wsl --update --pre-release; wsl ~"
## Will solve this problem.
## In case if it doesn't help, run pwsh as 'Admin' and do same thing

# locale
sudo localectl set-locale ja_JP.UTF-8
sudo localectl set-keymap jp106
echo "export LC_ALL=C" >> ~/.bashrc
## コマンド類のエラーメッセージを英語にする

# font (Maple Mono)
git clone https://aur.archlinux.org/paru.git ~/paru
echo `cd paru; makepkg -si`

# gimp
# sudo pacman -S ffmpeg
# sudo pacman -S ghostscript
# sudo pacman -S gimp

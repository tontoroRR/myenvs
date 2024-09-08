#!/bin/bash
# Run this script from root
# Enable Japan server in mirror list
sed -i -e "s/^Server/#Server/" /etc/pacman.d/mirrorlist
sed -i -e "s/#\(Server.*jaist.*\)/\1/" /etc/pacman.d/mirrorlist

# Reset key
pacman-key --init
pacman-key --populate archlinux
pacman -Syy --noconfirm archlinux-keyring

# Update package
pacman -Syu --noconfirm

# add default user in wheel group 
USERNAME=****
PASSWORD=****
useradd --create-home $USERNAME
echo "$USERNAME:$PASSWORD" | chpasswd
usermod -aG wheel $USERNAME

# Allow sudo for wheel members
pacman -S --noconfirm vi sudo
sed -i -e "s/# \(.*%wheel.*\)/\1/" /etc/sudoers

# Install apps
pacman -S --noconfirm base-devel git wget neovim
pacman -S --noconfirm zoxide ripgrep fd fzf
pacman -S --noconfirm tree-sitter # libcuda.so.1 is not symbolic linkというエラーになるかもしれない
# そんな時は→ https://superuser.com/questions/1707681/wsl-libcuda-is-not-a-symbolic-link

# Switch user and install yay
su $USERNAME
cd ~; mkdir abs
git clone https://aur.archlinux.org/yay.git; cd yay
makepkg -si --noconfirm
cd ~
yay -Syu # Manual intervention required

# asdf
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.1
echo . "\$HOME/.asdf/asdf.sh" >> ~/.bashrc
echo . "\$HOME/.asdf/completions/asdf.bash" >> ~/.bashrc
. .bashrc

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

# Last: set default user
cmd.exe /C "Arch.exe config --default-user $USERNAME"

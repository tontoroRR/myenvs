#!/bin/bash

sudo dnf update -y
sudo dnf install -y kernel-devel make gcc bzip2 perl
sudo reboot

sudo /run/media/$USER/VBox_GA_xxxx/VBoxLinuxAdditions.run

sudo usermod -aG vboxsf $USER

# Language/Keymap
sudo localectl set-keymap jp106
echo "export LC_ALL=C" >> ~/.bashrc

# Generate key for ssh with PSA
ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa <<<y
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 700 ~/.ssh
chmod 600 ~/.ssh/*

# Enable sshd
sudo systemctl enable sshd
sudo systemctl start sshd

# Add DISPLAY setting to bash
cat <<EOL >> ~/.bashrc

# Set DISPLAY
if [[ -v SSH_CLIENT ]];
then
	export DISPLAY=\$(echo \$SSH_CLIENT|cut -f1 -d" "):0.0
fi
EOL

# asdf install
sudo dnf install -y curl git
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.1
cat <<EOL >> ~/.bashrc

# Set asdf
. "\$HOME/.asdf/asdf.sh"
. "\$HOME/.asdf/completions/asdf.bash"
EOL
. ~/.bashrc

# install by asdf
## ruby
asdf plugin add ruby
asdf install ruby latest
asdf global ruby latest
## python
asdf plugin add python
asdf install python latest
asdf global python latest
## lua
asdf plugin add lua
asdf install lua 5.1
asdf global lua 5.1
## node
asdf plugin add nodejs
asdf install nodejs latest
asdf global nodejs latest

## libraries
npm install -g neovim
npm install -g yarn
gem install neovim
pip install --user --upgrade pynvim

# Maple Mono Font
cd /tmp
wget -P https://github.com/subframe7536/maple-font/releases/download/v7.0-beta26/MapleMono-NF-CN.zip
unzip MapleMono-NF-CN.zip
sudo mkdir -p /usr/local/share/fonts/maplemono
sudo mv MapleMono*.ttf /usr/local/share/fonts/maplemono/.
sudo mv config.json LICENCE.txt /usr/local/share/fonts/maplemono/.
sudo fc-cache -v
fc-list | grep maple

# torrent
dnf install transmission
pip install stig
dnf install transmission-cli


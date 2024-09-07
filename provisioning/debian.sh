#!/bin/bash

# 
sudo apt update -y
sudo apt upgrade -y
sudo apt install -y unzip curl xxd libfuse2
sudo apt install -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev wget libbz2-dev
sudo apt install -y libyaml-dev universal-ctags

# git
sudo apt remove -y git
sudo add-apt-repository ppa:git-core/ppa
sudo apt -y update
sudo apt -y install git

# asdf
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.1
echo . "\$HOME/.asdf/asdf.sh" >> ~/.bashrc
echo . "\$HOME/.asdf/completions/asdf.bash" >> ~/.bashrc
. .bashrc

# install rust tools
asdf plugin add zoxide
asdf install zoxide latest
asdf global zoxide latest
echo eval "\"\$(zoxide init bash)\"" >> ~/.bashrc
sudo apt install -y ripgrep
sudo apt install -y fd-find
wget https://github.com/junegunn/fzf/releases/download/v0.55.0/fzf-0.55.0-linux_amd64.tar.gz
tar zxvf fzf-0.55.0-linux_amd64.tar.gz
sudo mv fzf /usr/local/bin
echo "[ -f ~/.fzf.bash ] && source ~/.fzf.bash" >> ~/.bashrc

# tree-sitter
wget https://github.com/tree-sitter/tree-sitter/releases/download/v0.23.0/tree-sitter-linux-x64.gz
gunzip tree-sitter-linux-x64.gz
chmod u+x tree-sitter-linux-x64
sudo mv tree-sitter-linux-x64 /usr/local/bin/tree-sitter

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
gem install neovim
pip install --user --upgrade pynvim

# nvim
wget https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
chmod u+x nvim.appimage
sudo mv nvim.appimage /usr/local/bin/nvim
mkdir -p ~/.config/nvim
cd ~/.config/nvim
wget https://raw.githubusercontent.com/tontoroRR/myenvs/main/init.lua 
cd ~

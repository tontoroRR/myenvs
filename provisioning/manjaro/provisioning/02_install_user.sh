#!/bin/bash

# asdf
git clone https://github.com/asdf-vm/asdf.git $HOME/.asdf --branch v0.14.1
cat <<'EOL' >> $HOME/.bashrc

# asdf setting
. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash
EOL
## load asdf for further installation process
. $HOME/.asdf/asdf.sh

# tools
## zoxide
asdf plugin add zoxide
asdf install zoxide latest
asdf global zoxide latest
cat <<'EOL' >> $HOME/.bashrc

# zoxide
eval "$(zoxide init bash)"
EOL
## fzf
git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
$HOME/.fzf/install --all

# language from asdf
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

# nvim setting and libraries
mkdir -p $HOME/.config/nvim
wget -O $HOME/.config/nvim/init.lua https://raw.githubusercontent.com/tontoroRR/myenvs/main/init.lua
## libraries for nvim
npm install -g neovim
npm install -g yarn
gem install neovim
pip install --user --upgrade pynvim

#!/bin/bash

# asdf
git clone https://github.com/asdf-vm/asdf.git $HOME/.asdf --branch v0.14.1
cat <<'EOL' >> $HOME/.bashrc

# asdf setting
. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash
EOL
. $HOME/.bashrc

# rust tools
sudo pacman -S --noconfirm ripgrep
sudo pacman -S --noconfirm fd
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
. $HOME/.bashrc

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

# nvim
sudo pacman -S --noconfirm neovim tree-sitter xsel
mkdir -p $HOME/.config/nvim
wget -O $HOME/.config/nvim/init.lua https://raw.githubusercontent.com/tontoroRR/myenvs/main/init.lua
## libraries for nvim
npm install -g neovim
npm install -g yarn
gem install neovim
pip install --user --upgrade pynvim

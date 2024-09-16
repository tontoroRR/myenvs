#!/bin/bash
#
# curl -o 12.sh https://raw.githubusercontent.com/tontoroRR/myenvs/main/provisioning/arch/12.setup_user.sh

# Add me to vboxsf group
# virtualbox-guest-utilsのインストールが必要
# systemctl enable --now vboxserviceも必要
sudo usermod -aG vboxsf $(whoami)

# rust tools
sudo pacman -S --noconfirm ripgrep fd
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install <<<yyy
cat <<'EOL' >> ~/.bashrc

# zoxide
export PATH=$PATH:$HOME/.local/bin
eval "$(zoxide init bash)"
EOL

# asdf
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.1
cat <<'EOL' >> ~/.bashrc

# asdf setting
. "$HOME/.asdf/asdf.sh"
. "$HOME/.asdf/completions/asdf.bash"
EOL
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

# neovim
sudo pacman -S --noconfirm xsel # copy/paste tool
wget https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz
tar zxvf nvim-linux64.tar.gz && mv nvim-linux64 .nvim
rm nvim-linux64.tar.gz
mkdir -p ~/.config/nvim
wget -O ~/.config/nvim/init.lua https://raw.githubusercontent.com/tontoroRR/myenvs/main/init.lua
cat <<'EOL' >> ~/.bashrc

# nvim
export PATH="$PATH:$HOME/.nvim/bin"'

# display
if [[ -v $SSH_CLIENT ]];
then
  export DISPLAY=$(echo $SSH_CLIENT|cut -f1 -d' '):0.0
fi
EOL
. .bashrc

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

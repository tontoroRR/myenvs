#!/bin/bash
#
# curl -o 12.sh https://raw.githubusercontent.com/tontoroRR/myenvs/main/provisioning/arch/12.setup_user.sh

# Add me to vboxsf group
usermod -aG vboxsf $(whoami)

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
## zoxide
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

asdf plugin add zoxide
asdf install zoxide latest
asdf global zoxide latest
echo 'eval "$(zoxide init bash)"' >> ~/.bashrc

echo '[ -f ~/.fzf.bash ] && source ~/.fzf.bash' >> ~/.bashrc

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

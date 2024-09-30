#!/bin/bash

# hostname
HOSTNAME=manjaro

hostnamectl set-hostname $HOSTNAME
echo $HOSTNAME > /etc/hostname
if grep 127.0.1.1 /etc/hosts 1>/dev/null 2>&1 ;
then
  sed -i -e "s/^127.0.1.1.*/127.0.1.1 $HOSTNAME/" /etc/hosts
else
  echo "127.0.1.1 $HOSTNAME" > /etc/hosts
fi

pacman -Syu --noconfirm
pacman -S --noconfirm base-devel openssh dhcpcd sudo vim unzip tk

# history
cat <<'EOL' > /etc/profile.d/my_history.sh
# shellcheck shell=sh

# history settings
export HISTTIMEFORMAT='%F %T '
export HISTFILESIZE=1000
export HISTSIZE=1000
# [Bashのhistoryで表示される重複したコマンドを消したい #Bash - Qiita](https://qiita.com/kuryus/items/47d1d64a1c424275c802)
export HISTCONTROL=ignoredups
export HISTIGNORE='ls:cd:pwd:whoami'
EOL
chmod a+x /etc/profile.d/history.sh

# ssh setting
cat <<'EOL' > /etc/profile.d/my_ssh.sh
# shellcheck shell=sh

export DISPLAY=${SSH_CLIENT%% *}:0.0
EOL
chmod a+x /etc/profile.d/ssh.sh

# locale & datetime
sed -i -e "s/^#\(en_US.UTF-8 UTF-8\)/\1/" /etc/locale.gen
sed -i -e "s/^#\(ja_JP.UTF-8 UTF-8\)/\1/" /etc/locale.gen
locale-gen
echo 'KEYMAP=jp106' > /etc/vconsole.conf
ls -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
hwclock --systohc --utc
timedatectl set-timezone Asia/Tokyo

# dhcp client service - not necessary
# systemctl enable --now dhcpcd.service
# Created symlink '/etc/systemd/system/multi-user.target.wants/dhcpcd.service' → '/usr/lib/systemd/system/dhcpcd.service'.

# sudoer
sed -i -e "s/^#.*\(Defaults env_keep += \"HOME\"$\)/\1/" /etc/sudoers
sed -i -e "s/^#.*\(%wheel ALL=(ALL:ALL) ALL$\)/\1/" /etc/sudoers

# nameserver
## set rc-manager
cat <<'EOL' > /etc/NetworkManager/conf.d/20-rc-manager.conf
[main]
rc-manager=resolvconf
EOL
## disable dns overwriting
cat <<'EOL' > /etc/NetworkManager/conf.d/99-dont-touch-my-dns.conf
[main]
dns=none
EOL
## add my dnf
cat <<EOL >> /etc/resolvconf.conf
name_servers="8.8.8.8 8.8.4.4"
EOL
## update
resolvconf -u

# disable ipv6
sed -i -e "s/\(GRUB_CMDLINE_LINUX=.*\)\"$/\1 ipv6.disable=1\"/" /etc/default/grub

# docker
pacman -S --no-confirm docker
pacman -S --no-confirm docker-compose
systemctl enable --now docker
systemctl enable --now containerd

# install yay & paru
## paru cannot be installed due to libalpm version incompatibility
## https://github.com/Morganamilo/paru/issues/1240
cat <<'EOL' > /etc/sudoers.d/02_aur
aur   ALL = (root) NOPASSWD: /usr/bin/makepkg, /usr/bin/pacman
EOL
useradd -m aur || true
cat <<'EOL' > install_pkg.sh
rm -rf /tmp/package-query ; mkdir -p /tmp/package-query ; cd /tmp/package-query ; wget https://aur.archlinux.org/cgit/aur.git/snapshot/package-query.tar.gz ; tar zxvf package-query.tar.gz ; cd package-query ; makepkg --syncdeps --rmdeps --install --noconfirm
rm -rf /tmp/yay ; mkdir -p /tmp/yay ; cd /tmp/yay ; wget https://aur.archlinux.org/cgit/aur.git/snapshot/yay.tar.gz ; tar zxvf yay.tar.gz ; cd yay ; makepkg --syncdeps --rmdeps --install --noconfirm
# rm -rf /tmp/paru ; mkdir -p /tmp/paru ; cd /tmp/paru ; wget https://aur.archlinux.org/cgit/aur.git/snapshot/paru.tar.gz ; tar zxvf paru.tar.gz ; cd paru ; makepkg --syncdeps --rmdeps --install --noconfirm
# rm -rf /tmp/paru ; mkdir -p /tmp/paru ; cd /tmp/paru ; git clone https://aur.archlinux.org/paru-git.git; cd paru-git ; makepkg --syncdeps --rmdeps --install --noconfirm
EOL
chmod a+x install_pkg.sh
su aur ./install_pkg.sh

# maple font
## paru -S --noconfirm ttf-maple
su - aur -c 'yay -S --noconfirm ttf-maple'

sudo pacman -S --noconfirm ripgrep fd neovim tree-sitter xsel

#!/bin/bash
# [arch Linuxのインストール手順 2023年最新版 #archLinux - Qiita]
# https://qiita.com/kurimochi/items/50f75a83781d53fa31c6
#
# curl -o 02.sh https://raw.githubusercontent.com/tontoroRR/myenvs/main/provisioning/arch/02.install_by_root.sh

# Locale
cp /etc/locale.gen ~/locale.gen_cp
cat ~/locale.gen_cp | sed -e "s/^#\(en_US.UTF-8 UTF-8\)/\1/" | sed -e "s/^#\(ja_JP.UTF-8 UTF-8\)/\1/" > /etc/locale.gen
locale-gen

# language and keymap
echo 'LANG=en_US.UTF-8' > /etc/locale.conf
echo 'KEYMAP=jp106' > /etc/vconsole.conf

# adjust time
# tzselect # 5, 20, 1 と入力 # /etc/localtimeを作っているので不要
ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
hwclock --systohc --utc

# set hostname
MY_HOSTNAME=arch
echo $MY_HOSTNAME > /etc/hostname
cat <<EOL > /etc/hosts
127.0.0.1 localhost
::1 localhost
127.0.1.1 $MY_HOSTNAME
EOL

# ???
mkinitcpio -p linux # 不要？
echo "$(whoami):pass" | chpasswd # set password

# dhcpcdサービス
systemctl enable dhcpcd@enp0s3.service

# IntelCPU用設定
# [Arch LinuxをVirtualBox上にインストール #archLinux - Qiita]
# (https://qiita.com/honeniq/items/579b36588f3c1061edf5)
pacman -S --noconfirm intel-ucode

# dosfstool
pacman -S --noconfirm dosfstool

# run auto install script
bootctl --path=/boot install # mkinicpioと似たメッセージが出る

# boot loader entry
cat <<EOL > /boot/loader/entries/arch.conf
title Arch Linux
linux /vmlinuz-linux
initrd /intel-ucode.img
initrd /initramfs-linux.img
options root=/dev/sda3 rw
EOL

cat <<EOL > /boot/loader/loader.conf
default arch
timeout 5
EOL

# NetworkManager(不要?)
# [ArchLinuxをインストールした直後に行う設定（GUI導入や日本語化、アーカイブ設定、Office、Bluetoothなど） #Bash - Qiita]
# https://qiita.com/Hayao0819/items/f23c6a6f1e103c5b6a83
# pacman -S --noconfirm networkmanager
# systemctl enable NetworkManager
# systemctl start NetworkManager

# grub
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB --boot-directory=/boot/efi/EFI --recheck
grub-mkconfig -o /boot/efi/EFI/grub/grub.cfg

# create non-root user
USERNAME=tontoro
useradd -m -g wheel -d /home/${USERNAME} -s /bin/bash -m $USERNAME
echo "$USERNAME:pass" | chpasswd

# Defaults env_keep += "HOME" の行と %wheel ALL=(ALL) ALL の行のコメントを解除
cp /etc/sudoers ~/sudoers.cp
cat ~/sudoers.cp | sed -e "s/^#.*\(Defaults env_keep += \"HOME\"$\)/\1/" | sed -e "s/^#.*\(%wheel ALL=(ALL:ALL) ALL$\)//\1/" > /etc/sudoers

# change to non-root user
su -l $USERNAME

# Generate key for ssh with PSA
ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa <<<y
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 700 ~/.ssh
chmod 600 ~/.ssh/*

exit
shotdown -h now

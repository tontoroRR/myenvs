#!/bin/bash
# [arch Linuxのインストール手順 2023年最新版 #archLinux - Qiita]
# https://qiita.com/kurimochi/items/50f75a83781d53fa31c6
#
# curl -o 02.sh https://raw.githubusercontent.com/tontoroRR/myenvs/main/provisioning/arch/02.install_by_root.sh

# Locale
cp /etc/locale.gen ~/locale.gen_copy
sed -e "s/^#\(en_US.UTF-8 UTF-8\)/\1/" ~/locale.gen_copy| sed -e "s/^#\(ja_JP.UTF-8 UTF-8\)/\1/" > /etc/locale.gen
locale-gen
rm locale.gen_copy

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

# grub
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB --boot-directory=/boot/efi/EFI --recheck
grub-mkconfig -o /boot/efi/EFI/grub/grub.cfg

# create non-root user
USERNAME=tontoro
useradd -m -g wheel -d /home/${USERNAME} -s /bin/bash -m $USERNAME
echo "$USERNAME:pass" | chpasswd

# Defaults env_keep += "HOME" の行と %wheel ALL=(ALL) ALL の行のコメントを解除
cp /etc/sudoers ~/sudoers_copy
sed -e "s/^#.*\(Defaults env_keep += \"HOME\"$\)/\1/" ~/sudoers_copy| sed -e "s/^#.*\(%wheel ALL=(ALL:ALL) ALL$\)/\1/" > /etc/sudoers

# Default DNSs
cat <<EOL > /etc/resolv.conf
nameserver 8.8.8.8
nameserver 8.8.4.4
EOL

# change to non-root user
su -l $USERNAME

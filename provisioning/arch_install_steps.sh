#!/bin/bash
#
# original
# 参考サイト： arch Linuxのインストール手順 2023年最新版
# https://qiita.com/kurimochi/items/50f75a83781d53fa31c6
#

loadkeys jp106
ls /sys/firmware/efi | grep efivars

# check disk
lsblk | grep -v 'rom\|loop\|airoot' # sdaと表示されるはず
# create partition
sgdisk -z /dev/sda
sgdisk -n 1:0:+512M -t 1:ef00 -c 1:"EFI System" /dev/sda
sgdisk -n 2:0:+512M -t 2:8300 -c 2:"Linux filesystem"　/dev/sda
sgdisk -n 3:0: -t 3:8300 -c 3:"Linux filesystem" /dev/sda
# format
mkfs.vfat -F32 /dev/sda1
mkfs.ext4 /dev/sda2
mkfs.ext4 /dev/sda3
# mount
mount /dev/sda3 /mnt
mkdir /mnt/boot
mount /dev/sda2 /mnt/boot
mkdir /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi

# add japanese server
echo 'Server = http://ftp.tsukuba.wide.ad.jp/Linux/archlinux/$repo/os/$arch' >> /etc/pacman.d/mirrotlist
# install packages
pacstrap /mnt base base-devel linux linux-firmware grub efibootmgr dosfstools netctl vim

# grub loader
# fstab
genfstab -U /mnt >> /mnt/etc/fstab

# chroot
arch-chroot /mnt /bin/bash

# Locale
cp /etc/locale.gen ~/locale.gen_cp
cat ~/locale.gen_cp | sed -e "s/^#\(en_US.UTF-8 UTF-8|)/\1/" | sed -e "s/^#\(ja_JP.UTF-8 UTF-8\)/\1/" > /etc/locale.gen
locale-gen

# language and keymap
echo 'LANG=en_US.UTF-8' > /etc/locale.conf
echo 'KEYMAP=jp106' > /etc/vconsole.conf

# adjust time
tzselect # 5, 20, 1 と入力
ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
hwclock --systohc --utc

# set hostname
MY_HOSTNAME=tontoro
echo $MY_HOSTNAME > /etc/hostname
cat <<EOL > /etc/hosts
127.0.0.1 localhost
::1 localhost
127.0.1.1 $MY_HOSTNAME
EOL

# ???
mkinitcpio -p linux
passwd # set password

# grub
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB --boot-directory=/boot/efi/EFI --recheck
grub-mkconfig -o /boot/efi/EFI/grub/grub.cfg
exit
shutdown -h now

# create user
USERNAME=tontoro
useradd -m -g wheel -d /home/${USERNAME} -s /bin/bash -m $USERNAME
passwd ${USERNAME}
# 画面の指示に従ってパスワードを設定
pacman -S sudo

# Defaults env_keep += "HOME" の行と %wheel ALL=(ALL) ALL の行のコメントを解除
cp /etc/sudoers ~/sudoers.cp
cat ~/sudoers.cp | sed -e "s/^#.*\(Defaults env_keep += \"HOME\"$\)/\1/" | sed -e "s/^#.*\(%wheel ALL=(ALL:ALL) ALL$\)//\1/" > /etc/sudoers

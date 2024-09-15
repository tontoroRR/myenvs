#!/bin/bash
#
# original
# 参考サイト： arch Linuxのインストール手順 2023年最新版
# https://qiita.com/kurimochi/items/50f75a83781d53fa31c6
#
# curl -o 01.sh https://raw.githubusercontent.com/tontoroRR/myenvs/main/provisioning/arch/01.install_from_iso.sh

loadkeys jp106
ls /sys/firmware/efi | grep efivars

# check disk
lsblk | grep -v 'rom\|loop\|airoot' # sdaと表示されるはず
# create partition
sgdisk -z /dev/sda;
sgdisk -n 1:0:+512M -t 1:ef00 -c 1:"EFI System" /dev/sda;
sgdisk -n 2:0:+512M -t 2:8300 -c 2:"Linux filesystem"　/dev/sda;
sgdisk -n 3:0: -t 3:8300 -c 3:"Linux filesystem" /dev/sda;
# format
mkfs.vfat -F32 /dev/sda1;
mkfs.ext4 /dev/sda2;
mkfs.ext4 /dev/sda3;
# mount
mount /dev/sda3 /mnt;
mkdir /mnt/boot;
mount /dev/sda2 /mnt/boot;
mkdir /mnt/boot/efi;
mount /dev/sda1 /mnt/boot/efi;

# add japanese server
sed -e "s/^Server/# Server/" /etc/pacman.d/mirrorlist > ~/mirrorlist
cat ~/mirrorlist > /etc/pacmand.d/mirrorlist
echo 'Server = http://ftp.tsukuba.wide.ad.jp/Linux/archlinux/$repo/os/$arch' >> /etc/pacman.d/mirrotlist

# install packages
pacstrap /mnt base base-devel linux linux-firmware grub efibootmgr dosfstools netctl vim openssh dhcpcd sudo

# grub loader
# fstab
genfstab -U /mnt >> /mnt/etc/fstab

# chroot
arch-chroot /mnt /bin/bash

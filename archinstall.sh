#!/usr/bin/env bash

echo "As of version 0.00.1, drives are not automatically formatted, follow the Arch Wiki for further information on how to properly partition and write your drive"

echo "Please choose your device"
echo "1. PC"
echo "2. Laptop"
read DESKTOP

echo "Please choose your CPU/GPU spec"
echo "1. AMD"
echo "2. Intel"
echo "3. Nvidia"
read CPU

echo "Choose your root password"
read PASSWD

echo "Choose your username"
read USER

echo "Choose your user's password"
read  USRPSWD

echo "What is your Windows EFI partition"
read WINEFI

# Timezone
timedatectl set-timezone America/New_York

# Mirrors
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
pacman -Sy
pacman -S 
rankmirrors -n 10 /etc/pacman.d/mirrorlist.bak > /etc/pacman.d/mirrorlist





# Pacstrap (ADD CPU/GPU ucodes for a variety of devices)
# this is AMD
Pacstrap -i /mnt base base-devel linux linux-headers linux-firmware mesa xf86-video-amdgpu amd-ucode vulkan-radeon sudo nano git neofetch networkmanager dhcpcd pipewire bluez wpa_supplicant 

# this is Intel
Pacstrap -i /mnt base base-devel linux linux-headers linux-firmware intel-ucode sudo nano git neofetch networkmanager dhcpcd pipewire bluez wpa_supplicant 

# this is Nvidia (sucks)
echo "Your CPU/GPU is incompatiable" 






# fstab
genfstab -U /mnt >> /mnt/etc/fstab

# Chroot time *MAY BE ISSUES HERE, DOUBLE CHECK*
arch-chroot /mnt
passwd $PASSWD
useradd -m $USER
passwd $USER $USRPSWD
usermod -aG wheel,storage,power,audio $USER

# Language setup
sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
export LANG=en_US.UTF-8

# Hostname
echo AUR > /etc/hostname
cat <<EOF > /etc/hosts
127.0.0.1	localhost
::1			localhost
127.0.1.1	AUR.localdomain    localhost
EOF

# Location pt2 in Chroot
ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime

# Grub
mkdir /boot/grub
mount /dev/$WINEFI /boot/grub/
pacman -S grub efibootmgr dosfstools mtools

# find a way to edit nano /etc/default/grub

pacman -S os-prober
grub-install --target=x86_64 -efi --efi-directory=/boot/grub --bootloader-id=grub_uefi --recheck
grub -mkconfig -o /boot/grub/grub.cfg

# enable the services installed
echo "If there are any error messages, do not worry, it is BOUND to happen"

systemctl enable dhcpcd.service
systemctl enable NetworkManager.service

# finish the system

exit
umount -lR /mnt
reboot 
#!/usr/bin/env bash

echo "As of version 0.00.2, drives are not automatically partitioned into EFI, SWAP or ROOT groups, follow the Arch Wiki for further information on how to properly partition and write your drive"

# Questionaire
echo "What is your perferred EFI partition"
read EFI

echo "What is your perferred SWAP partition"
read SWAP

echo "What is your perferred ROOT partition"
read ROOT

echo "Please choose your device"
echo "1. PC"
echo "2. Laptop"
echo "Only write the number!"
read DESKTOP

echo "Please choose your CPU/GPU spec"
echo "1. AMD"
echo "2. Intel"
echo "3. Nvidia"
echo "Only write the number!"
read CPU

echo "Choose your root password"
read PASSWD

echo "Choose your username"
read USER

echo "Choose your user's password"
read  USRPSWD

echo "Choose your hostname password"
read  HOST

echo "What is your Dual-Boot EFI partition"
echo "example: Nvme0n1p1 for windows"
echo "If none, write NONE" 
read WINEFI

mkfs.ext4 /dev/$ROOT
mkswap /dev/$SWAP
swapon /dev/$SWAP
mkfs.fat -F 32 /dev/$EFI
mount /dev/$ROOT /mnt
mount --mkdir /dev/$EFI /mnt/boot

# Timezone
timedatectl set-timezone America/New_York


# Mirrors
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
pacman -Sy
pacman -S 
rankmirrors -n 10 /etc/pacman.d/mirrorlist.bak > /etc/pacman.d/mirrorlist

# Pacstrap (ADD CPU/GPU ucodes for a variety of devices)
case $CPU in
    1)
        pacstrap -i /mnt base base-devel linux linux-headers linux-firmware mesa xf86-video-amdgpu amd-ucode vulkan-radeon sudo nano git neofetch networkmanager dhcpcd pipewire bluez wpa_supplicant bluez-utils
        ;;
    2)
        pacstrap -i /mnt base base-devel linux linux-headers linux-firmware intel-ucode xf86-video-intel sudo nano git neofetch networkmanager dhcpcd pipewire bluez wpa_supplicant bluez-utils
        ;;
    3)
        pacstrap -i /mnt base base-devel linux linux-headers linux-firmware nvidia sudo nano git neofetch networkmanager dhcpcd pipewire bluez wpa_supplicant bluez-utils
        ;;
    *)
        echo "Invalid choice. Please choose a number between 1 and 3."
        ;;
esac

case $DESKTOP in
    1)
        echo "Installed!"
        ;; 
    2)
        pacstrap -i /mnt tlp brightnessctl lm_sensors libinput
        ;;
esac

# fstab
genfstab -U /mnt >> /mnt/etc/fstab

# Chroot time *MAY BE ISSUES HERE, DOUBLE CHECK*
arch-chroot /mnt
passwd $PASSWD
useradd -m $USER
passwd $USER $USRPSWD
usermod -aG wheel,storage,power,audio $USER

sed -i '/^# %wheel ALL=(ALL:ALL) ALL/s/^# //' /etc/sudoers


arch-chroot /mnt bash -c "ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime && hwclock --systohc && sed -i 's/#en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen && locale-gen && echo 'LANG=en_US.UTF-8' > /etc/locale.conf && exit"

	arch-chroot /mnt bash -c "echo $HOST > /etc/hostname && echo 127.0.0.1	$HOST > /etc/hosts && echo ::1	$HOST >> /etc/hosts && echo 127.0.1.1	$HOST.localdomain	$HOST >> /etc/hosts && exit"
    locale-gen
    export LANG=en_US.UTF-8
	arch-chroot /mnt bash -c "passwd && useradd --create-home $USER && echo 'set user password' && passwd $USER && groupadd sudo && gpasswd -a $USER sudo && EDITOR=vim visudo && exit"

	arch-chroot /mnt bash -c "systemctl enable bluetooth && exit"
	arch-chroot /mnt bash -c "systemctl enable NetworkManager && exit"
	
	arch-chroot /mnt bash -c "systemctl enable paccache.timer && exit"

	echo -e "Editing configuration files...\n"
	# Enabling multilib in pacman
	arch-chroot /mnt bash -c "sed -i '93s/#\[/\[/' /etc/pacman.conf && sed -i '94s/#I/I/' /etc/pacman.conf && pacman -Syu && sleep 1 && exit"

# Location pt2 in Chroot
ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime

# Grub
if [ "$WINEFI" != "NONE" ]; then
mkdir /boot/grub
mount /dev/$WINEFI /boot/grub/
pacman -S grub efibootmgr dosfstools mtools

# Edit /etc/default/grub and uncomment GRUB_DISABLE_OS_PROBER
if [ -f /etc/default/grub ]; then
    sed -i '/^# *GRUB_DISABLE_OS_PROBER=/s/^#//' /etc/default/grub
    echo "GRUB configuration updated."
else
    echo "Error: /etc/default/grub file not found."
fi
pacman -S os-prober
grub-install --target=x86_64 -efi --efi-directory=/boot/grub --bootloader-id=grub_uefi --recheck
grub -mkconfig -o /boot/grub/grub.cfg
fi 

# enable the services installed

case $DESKTOP in
    1)
        lsblk
        ;; 
    2)
        arch-chroot /mnt bash -c "systemctl enable bluetooth"
        arch-chroot /mnt bash -c "systemctl start bluetooth"
        arch-chroot /mnt bash -c "systemctl enable tlp"
        arch-chroot /mnt bash -c "systemctl start tlp"
        ;;
esac

arch-chroot /mnt bash -c "systemctl enable dhcpcd.service"
arch-chroot /mnt bash -c "systemctl enable NetworkManager.service"

# finish the system
exit
umount -lR /mnt

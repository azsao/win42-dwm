#!/bin/bash

sudo pacman -Syu --noconfirm
sudo pacman -Syy --noconfirm
sudo pacman -Sy --noconfirm

time (5)

sudo pacman -S --noconfirm git feh pipewire-pulse pactl neovim xclip git pavucontrol xorg-xinit xorg-server terminus-font libxft libx11 libxinerama freetype2 base-devel fontconfig


mkdir .suckless
cd .suckless
git clone https://git.suckless.org/dwm
git clone https://git.suckless.org/st
git clone https://git.suckless.org/dmenu
git clone https://github.com/torrinfail/dwmblocks.git

time (5)

cd .suckless/dwm
make
sudo make clean install

cd .suckless/st
make
sudo make clean install

cd .suckless/dmenu
make
sudo make clean install

cd ~/.suckless/dwmblocks
make
sudo make clean install

time (5)

# dependencies for config


sudo pacman -S --noconfirm pipewire pipewire-pulse pw-volume
sudo pacman -S --noconfirm xclip
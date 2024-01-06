#!/bin/bash

sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm git

time (5)

sudo pacman -S --noconfirm base-devel libx11 libxft libxinerama freetype2 fontconfig
sudo pacman -S --noconfirm xorg-server xorg-xinit xorg-xrandr xorg-xsetroot

mkdir .suckless
cd .suckless
git clone https://git.suckless.org/dwm
git clone https://git.suckless.org/st
git clone https://git.suckless.org/dmenu

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
cd

time (5)
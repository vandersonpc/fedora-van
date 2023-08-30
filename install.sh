#!/bin/bash

##
## Fedora install script 
##
## Install the Fedora server and run this installation as sudo

## Check if Script is Run as Root

if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user to run this script, please run sudo ./install.sh" 2>&1
  exit 1
fi

## Updade DFN

dnf update
dnf clean all

## Install ROM fusion 

dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y
dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
dnf config-manager --set-enabled rpmfusion-free
dnf config-manager --set-enabled rpmfusion-nonfree
dnf groupupdate core

## Install essential packages

dnf install bspwm lightdm git alacritty vim dconf-editor rofi thunar thunar-archive-plugin sxhkd arandr lxappearance picom nitrogen neofetch firefox polybar dunst xclip screenshot spectacle ark xcfe4-power-manager copyq -y

# set light dm as default login
systemctl enable lightdm
systemctl set-default graphical.target

## Install Fonts

dnf install fonttosfnt fontawesome5-brands-fonts fontawesome5-free-fonts ipa-gothic-fonts material-icons-fonts -y
mkdir -p $HOME/.fonts && cd $HOME/.fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/FiraCode.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/Hack.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/CascadiaCode.zip
unzip FiraCode.zip
unzip CascadiaCode.zip
unzip Hack.zip
rm -rf *.zip
fc-cache -vf

## Copy default config 
## Add github once installed 

mkdir -p ~/.config/bspwm
mkdir -p ~/.config/sxhkd
cp /usr/share/doc/bspwm/examples/bspwmrc ~/.config/bspwm/
cp /usr/share/doc/bspwm/examples/sxhkdrc  ~/.config/sxhkd/
sudo systemctl restart lightdm
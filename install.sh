#!/bin/bash

##
## Fedora configuration script
##
## Install the base Fedora gnome and run the script
##
## AUG/2023 - By Vandermann 
##
##

## Check if Script is Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user to run this script, please run sudo ./install.sh" 2>&1
  exit 1
fi

## Get username and installation folder
username=$(id -u -n 1000)
builddir=$(pwd)

## Making .config and copying all setings and background
mkdir -p /home/$username/.config
mkdir -p /home/$username/.fonts
mkdir -p /home/$username/.themes
mkdir -p /home/$username/Pictures/backgrounds

cp -R dotconfig/* /home/$username/.config/
cp bg.jpg /home/$username/Pictures/backgrounds/
cp fedora.png /home/$username/Pictures/backgrounds/
#cp -R usr/* /usr/
cp -R etc/* /etc/

## Download Nordic Theme
cd /usr/share/themes/
git clone https://github.com/EliverLara/Nordic.git

## Install Nordzy cursor
cd $builddir 
git clone https://github.com/alvatip/Nordzy-cursors
cd Nordzy-cursors
./install.sh
cd $builddir 
rm -rf Nordzy-cursors

## Synth Shell
git clone --recursive https://github.com/andresgongora/synth-shell.git
chmod +x synth-shell/setup.sh
cd synth-shell/
./setup.sh
cd $builddir 
rm -rf synth-shell

## Updade DFN
dnf update
#dnf clean all

## Restore settings
dnf install dconf -y
dconf load -f / < saved_settings.dconf

## Install RPM fusion packages 
dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y
dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
dnf config-manager --set-enabled rpmfusion-free
dnf config-manager --set-enabled rpmfusion-nonfree
dnf groupupdate core

## Third party repositories
dnf install fedora-workstation-repositories -y

## Gnome extensions APP
dnf install gnome-extensions-app #https://github.com/essembeh/gnome-extensions-cli

## Install gnome extension installer
dnf install python3-pip -y
pip3 install --upgrade gnome-extensions-cli

## Install gnome extensions
gnome-extensions-cli --filesystem install tactile@lundal.io 
gnome-extensions-cli --filesystem install blur-my-shell@aunetx
gnome-extensions-cli --filesystem install Move_Clock@rmy.pobox.com
gnome-extensions-cli --filesystem install clipboard-indicator@tudmotu.com
gnome-extensions-cli --filesystem install openweather-extension@jenslody.de
gnome-extensions-cli --filesystem install Vitals@CoreCoding.com
gnome-extensions-cli --filesystem install dash-to-dock@micxgx.gmail.com
gnome-extensions-cli --filesystem install drive-menu@gnome-shell-extensions.gcampax.github.com
gnome-extensions-cli --filesystem install Hide_Activities@shay.shayel.org
gnome-extensions-cli --filesystem install no-overview@fthx

## Enable gnome Extensions  
gnome-extensions-cli enable apps-menu@gnome-shell-extensions.gcampax.github.com
gnome-extensions-cli enable background-logo@fedorahosted.org

## Install packages
dnf install gnome-tweaks ulauncher unzip autokey-gtk wget dnf-plugins-core putty pulseview p7zip thunar thunar-archive-plugin spectacle gimp -y
dnf install neofetch smartmontools vim kdiskmark qemu flatseal -y

## Brave browser
dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
dnf install brave-browser brave-keyring

## Google Chrome
dnf config-manager --set-enabled google-chrome
dnf install google-chrome-stable -y

## Wine
dnf config-manager --add-repo https://dl.winehq.org/wine-builds/fedora/38/winehq.repo
dnf install winehq-stable -y

## Programming
dnf install spyder conda ipython -y 
dnf install python3-usb -y

## Add USB group used by Python to access usb ports
groupadd usbusers
usermod -a -G usbusers $username

## Arduino via flatpack
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install cc.arduino.arduinoide -y

## add user to dialup required to access the serial ports
usermod -a -G dialout $username
usermod -a -G tty $username

## Install VSCode
rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo
dnf check-update
sudo dnf install code # or code-insiders

## Install Python libraries
python -m pip install pyusb
pip install python3-usb pyqt6-tools pyqt6 pyqt5 pyvisa colorlog numpy pandas matplotlib pyqtgraph pyvisa-py zeroconf pint stringparser pyserial

## Kicad
dnf copr enable @kicad/kicad-stable -y
dnf install kicad kicad-packages3d kicad-doc -y

## Onenote linux
wget https://github.com/patrikx3/onenote/releases/download/v2023.10.235/p3x-onenote-2023.10.235.x86_64.rpm
dnf localinstall p3x-onenote-2023.10.235.x86_64.rpm -y
rm -f p3x-onenote-2023.10.235.x86_64.rpm

## NVidia driver 
# Uncomment to use on Vaio Laptop
#dnf install xorg-x11-drv-nvidia-470xx akmod-nvidia-470xx -y

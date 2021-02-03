# fs-uae-pi-install-script
Script to install FS-UAE on to a fresh install of Raspberry Pi OS.


## How to install FS-UAE 3.0.5 on Raspberry Pi
-------------------------------------------

## To run:

curl -sSL https://git.io/Jt4Du | sudo bash

The script does the following:

### Debian Backports
echo 'deb http://deb.debian.org/debian buster-backports main contrib non-free' | sudo tee -a /etc/apt/sources.list

sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 04EE7237B7D453EC 648ACFD622F3D138

### Add lha support
sudo touch /etc/apt/sources.list.d/FrodeSolheim-stable.list

echo 'deb https://download.opensuse.org/repositories/home:/FrodeSolheim:/stable/Raspbian_10/ /' | sudo tee -a /etc/apt/sources.list.d/FrodeSolheim-stable.list

wget https://download.opensuse.org/repositories/home:FrodeSolheim:stable/Debian_10/Release.key

sudo apt-key add - < Release.key

### Install FS-UAE
sudo apt update

sudo apt install -y -t buster-backports fs-uae fs-uae-launcher

sudo apt install -y python3-lhafile

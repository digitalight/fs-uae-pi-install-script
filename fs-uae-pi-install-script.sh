#!/bin/bash
# BASH SCRIPT TO INSTALL LATEST FS-UAE on Raspberry Pi


REQUIRED_PKG="fs-uae"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
echo Checking for $REQUIRED_PKG: $PKG_OK
if [ "install ok installed" = "$PKG_OK" ]; then
  echo "FS-UAE is already installed. Please remove first."
  exit 
fi
if [ "" = "$PKG_OK" ]; then
  echo "Installing FS-UAE"
    if grep -q buster-backports "/etc/apt/sources.list"; then
      echo "Buster Backports already added!"
      exit
    else
      echo "Adding Buster Backports"
      echo 'deb http://deb.debian.org/debian buster-backports main contrib non-free' | sudo tee -a /etc/apt/sources.list
      sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 04EE7237B7D453EC 648ACFD622F3D138
      # Adding FS-UAE Repo
      sudo touch /etc/apt/sources.list.d/FrodeSolheim-stable.list
      echo 'deb https://download.opensuse.org/repositories/home:/FrodeSolheim:/stable/Raspbian_10/ /' | sudo tee -a /etc/apt/sources.list.d/FrodeSolheim-stable.list
      wget https://download.opensuse.org/repositories/home:FrodeSolheim:stable/Debian_10/Release.key
      sudo apt-key add - < Release.key
      sudo apt update
      sudo apt install -y -t buster-backports fs-uae fs-uae-launcher
      sudo apt install -y python3-lhafile
      echo "Installation Complete"
    fi
  exit 
fi


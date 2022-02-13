#!/bin/bash
# BASH SCRIPT TO INSTALL LATEST FS-UAE on Raspberry Pi

# Check Raspberry Pi and OS version
MODEL=$(cat /proc/device-tree/model)
ID=$(grep -oP '(?<=^ID=).+' /etc/os-release | tr -d '"')S

# Check if FS-UAE is already installed
REQUIRED_PKG="fs-uae"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG | grep "install ok installed")
echo Checking for $REQUIRED_PKG: $PKG_OK
if [ "install ok installed" = "$PKG_OK" ]; then
  echo "FS-UAE is already installed. Please remove first."
  exit
fi
# Start Install
if [ "" = "$PKG_OK" ]; then
  echo "Installing FS-UAE"
  # OS is Buster
  if [ "$VERSION" = "10" ]; then
    # check if backports is added already
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
      curl -fsSL https://download.opensuse.org/repositories/home:FrodeSolheim:stable/Debian_10/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_FrodeSolheim_stable.gpg > /dev/null
      sudo apt update
      sudo apt install -y -t buster-backports fs-uae fs-uae-launcher
      sudo apt install -y python3-lhafile
      echo "Installation Complete"
    fi
  # OS is Bullseye
  elif [ "$VERSION" = "11" ]; then
    sudo touch /etc/apt/sources.list.d/FrodeSolheim-stable.list
    echo 'deb http://download.opensuse.org/repositories/home:/FrodeSolheim:/stable/Debian_11/ /' | sudo tee /etc/apt/sources.list.d/FrodeSolheim:stable.list
    curl -fsSL https://download.opensuse.org/repositories/home:FrodeSolheim:stable/Debian_11/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_FrodeSolheim_stable.gpg > /dev/null
    sudo apt update
    sudo apt install -y fs-uae fs-uae-launcher python3-lhafile
  else
    echo "Version detected is not Buster or Bullseye, stopping script"
    exit
  fi
  exit
fi

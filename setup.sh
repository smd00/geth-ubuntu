#!/bin/bash

# =============================================
# Author: smd00
# URL: https://github.com/smd00/geth-ubuntu
# Cheat sheet: https://medium.com/@danielmontoyahd/cheat-sheet-parity-and-bitcoin-core-c370163fca44

# Usage:
# git clone https://github.com/smd00/geth-ubuntu.git && cd geth-ubuntu
# sudo chmod +x ./setup.sh
# ./setup.sh

# =============================================
# OPTIONAL: Setup additional volume to store data
echo "# START -----------------------------------------------------------------"
echo "# SMD00    mount volume"
echo "# END   -----------------------------------------------------------------"
lsblk #Check the volume name (i.e. xvdb)
sudo mkfs.ext4 /dev/xvdb #Format the volume to ext4 filesystem
sudo mkdir /dmdata #Create a directory to mount the new volume
sudo mount /dev/xvdb /dmdata/ #Mount the volume to dmdata directory
df -h /dmdata #Check the disk space to confirm the volume mount

#EBS Automount on Reboot
sudo cp /etc/fstab /etc/fstab.bak
echo "/dev/xvdb  /dmdata/  ext4    defaults,nofail  0   0" | sudo tee -a /etc/fstab #Make a new entry in /etc/fstab
sudo mount -a #Check if the fstab file has any errors

lsblk #List the available disks
sudo file -s /dev/xvdb #Check if the volume has any data

# =============================================
# SMD00
echo "# START -----------------------------------------------------------------"
echo "# SMD00    Enable Geth launchpad repository"
echo "# END   -----------------------------------------------------------------"
sudo add-apt-repository -y ppa:ethereum/ethereum

echo "# START -----------------------------------------------------------------"
echo "# SMD00    System updates"
echo "# END   -----------------------------------------------------------------"
sudo apt-get update

echo "# START -----------------------------------------------------------------"
echo "# SMD00    Install Geth"
echo "# END   -----------------------------------------------------------------"
sudo apt-get install ethereum -y

echo "# START -----------------------------------------------------------------"
echo "# SMD00    Copy geth.service and config.toml"
echo "# END   -----------------------------------------------------------------"

cat $HOME/geth.service | sudo tee /etc/systemd/system/geth.service
cat $HOME/config.toml | sudo tee /dmdata/config.toml

sudo chmod +x /etc/systemd/system/geth.service

sudo chown -R ubuntu:ubuntu /dmdata

echo "# START -----------------------------------------------------------------"
echo "# SMD00    Enable and start geth"
echo "# END   -----------------------------------------------------------------"
sudo systemctl enable geth
sudo systemctl start geth

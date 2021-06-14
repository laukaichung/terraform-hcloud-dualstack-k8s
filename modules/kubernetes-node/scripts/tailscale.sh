#!/bin/bash

if [[ -z "$1" ]]; then
    echo "Please generate a pre-auth key in the Tailscale panel" 1>&2
    exit 1
fi

#https://tailscale.com/download
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.gpg | sudo apt-key add -
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.list | sudo tee /etc/apt/sources.list.d/tailscale.list

sudo apt-get update
sudo apt-get install tailscale -y
sudo tailscale up --authkey $1

# https://tailscale.com/kb/1077/secure-server-ubuntu-18-04/
sudo ufw allow 41641/udp
sudo ufw allow 24601

sudo ufw allow 6443/tcp
sudo ufw allow in on tailscale0 to any port 22

#sudo ufw allow in on tailscale0 to any port 2379
#sudo ufw allow in on tailscale0 to any port 2380
#sudo ufw allow in on tailscale0 to any port 6443
#sudo ufw allow in on tailscale0 to any port 10250
#sudo ufw allow in on tailscale0 to any port 10251
#sudo ufw allow in on tailscale0 to any port 10252

echo "y" | sudo ufw enable
# //todo temporarily setting allow incoming for testing.
#sudo ufw default deny incoming
sudo ufw default allow incoming
sudo ufw default allow outgoing
sudo ufw reload
sudo service ssh restart
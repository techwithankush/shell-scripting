#!/bin/bash

# Update package repositories and upgrade existing packages
sudo apt update
sudo apt upgrade -y

# Install required packages
sudo apt install -y package1 package2 package3

# Configure network settings (replace IP_ADDRESS, GATEWAY, and DNS_SERVERS with appropriate values)
sudo cat > /etc/network/interfaces <<EOF
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address IP_ADDRESS
    gateway GATEWAY
    dns-nameservers DNS_SERVERS
EOF

# Apply network settings
sudo ifdown eth0 && sudo ifup eth0

# Create a new user (replace USERNAME with your desired username)
sudo adduser USERNAME --gecos "User for DevOps project"

# Grant sudo privileges to the new user
sudo usermod -aG sudo USERNAME

# Harden SSH configuration
sudo sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
sudo sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo service ssh restart

# (Optional) Configure firewall rules using UFW
sudo ufw allow OpenSSH
sudo ufw enable

# (Optional) Install and configure other software, services, or custom configurations as needed.

# Display completion message
echo "Server setup and configuration completed!"

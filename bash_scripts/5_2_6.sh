#!/bin/bash

# Check if the system is Ubuntu 18.04 LTS
if [[ $(lsb_release -rs) == "18.04" && $(lsb_release -is) == "Ubuntu" ]]; then
    echo "The system is Ubuntu 18.04 LTS."
else
    echo "The system is not Ubuntu 18.04 LTS."
    exit 1
fi

# Backup the original sshd_config file
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

# Set the X11Forwarding parameter to no
if grep -q "^X11Forwarding" /etc/ssh/sshd_config; then
    sudo sed -i "s/^X11Forwarding.*/X11Forwarding no/" /etc/ssh/sshd_config
else
    echo "X11Forwarding no" | sudo tee -a /etc/ssh/sshd_config
fi

# Restart the SSH service to apply changes
echo "Restarting the SSH service..."
sudo systemctl restart sshd

echo "The X11Forwarding parameter has been set to no in /etc/ssh/sshd_config."
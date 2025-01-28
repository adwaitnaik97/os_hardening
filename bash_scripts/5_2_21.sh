#!/bin/bash

# Check if the system is Ubuntu 18.04 LTS
if [[ $(lsb_release -rs) == "18.04" && $(lsb_release -is) == "Ubuntu" ]]; then
    echo "The system is Ubuntu 18.04 LTS."
else
    echo "The system is not Ubuntu 18.04 LTS."
    exit 1
fi

# Check allowtcpforwarding parameter value
# Backup the original sshd_config file
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

# Set the AllowTcpForwarding parameter to no
if grep -q "^AllowTcpForwarding" /etc/ssh/sshd_config; then
    sudo sed -i "s/^AllowTcpForwarding.*/AllowTcpForwarding no/" /etc/ssh/sshd_config
else
    echo "AllowTcpForwarding no" | sudo tee -a /etc/ssh/sshd_config
fi

# Restart the SSH service to apply changes
echo "Restarting the SSH service..."
sudo systemctl restart sshd

echo "The AllowTcpForwarding parameter has been set to no in /etc/ssh/sshd_config."
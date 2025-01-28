#!/bin/bash

# Check if the system is Ubuntu 18.04 LTS
if [[ $(lsb_release -rs) == "18.04" && $(lsb_release -is) == "Ubuntu" ]]; then
    echo "The system is Ubuntu 18.04 LTS."
else
    echo "The system is not Ubuntu 18.04 LTS."
    exit 1
fi

# Set ClientAliveInterval to 300
if grep -Ei "^\s*ClientAliveInterval\s+[0-9]+" /etc/ssh/sshd_config; then
    echo "The ClientAliveInterval parameter is already set. Updating it to 300..."
    sudo sed -i 's/^\s*ClientAliveInterval\s\+[0-9]\+/ClientAliveInterval 300/' /etc/ssh/sshd_config
else
    echo "The ClientAliveInterval parameter is not set. Adding it with value 300..."
    echo "ClientAliveInterval 300" | sudo tee -a /etc/ssh/sshd_config
fi

# Set ClientAliveCountMax to 0
if grep -Ei "^\s*ClientAliveCountMax\s+[0-9]+" /etc/ssh/sshd_config; then
    echo "The ClientAliveCountMax parameter is already set. Updating it to 0..."
    sudo sed -i 's/^\s*ClientAliveCountMax\s\+[0-9]\+/ClientAliveCountMax 0/' /etc/ssh/sshd_config
else
    echo "The ClientAliveCountMax parameter is not set. Adding it with value 0..."
    echo "ClientAliveCountMax 0" | sudo tee -a /etc/ssh/sshd_config
fi

# Restart the SSH service to apply changes
echo "Restarting the SSH service..."
sudo systemctl restart sshd

echo "The ClientAliveInterval parameter has been set to 300 and ClientAliveCountMax has been set to 0."
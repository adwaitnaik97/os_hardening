#!/bin/bash

# Check if the system is Ubuntu 18.04 LTS
if [[ $(lsb_release -rs) == "18.04" && $(lsb_release -is) == "Ubuntu" ]]; then
    echo "The system is Ubuntu 18.04 LTS."
else
    echo "The system is not Ubuntu 18.04 LTS."
    exit 1
fi

# Check if the sshd service is running
if [[ $(systemctl is-active sshd) == "active" ]]; then
    echo "The sshd service is running."
else
    echo "The sshd service is not running."
    sudo apt install openssh-server
fi

# Define the approved ciphers
approved_ciphers="chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr"

# Check for the weak ciphers
if [[ $(sudo sshd -T | grep -i ciphers) != "ciphers $approved_ciphers" ]]; then
    echo "The weak ciphers are enabled. Updating the sshd_config file."

    # Backup the original sshd_config file
    sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

    # Add or modify the Ciphers line in the sshd_config file
    if grep -q "^Ciphers" /etc/ssh/sshd_config; then
        sudo sed -i "s/^Ciphers.*/Ciphers $approved_ciphers/" /etc/ssh/sshd_config
    else
        echo "Ciphers $approved_ciphers" | sudo tee -a /etc/ssh/sshd_config
    fi

    # Restart the sshd service to apply changes
    sudo systemctl restart sshd

    echo "The Ciphers line has been updated in /etc/ssh/sshd_config."
else
    echo "The weak ciphers are not enabled."
fi
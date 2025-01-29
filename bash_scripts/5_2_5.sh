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

# Verify the loglevel parameter is set to VERBOSE or INFO
if grep -q "^LogLevel" /etc/ssh/sshd_config; then
    sudo sed -i "s/^LogLevel.*/LogLevel VERBOSE/" /etc/ssh/sshd_config
else
    echo "LogLevel VERBOSE" | sudo tee -a /etc/ssh/sshd_config
fi
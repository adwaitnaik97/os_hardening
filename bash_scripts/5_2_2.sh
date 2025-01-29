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

# Verify the Uid is 0/root and Gid is 0/root
if [[ $(stat -c %u /etc/ssh/sshd_config) == 0 && $(stat -c %g /etc/ssh/sshd_config) == 0 ]]; then
    echo "The Uid and Gid are 0/root."
else
    echo "The Uid and Gid are not 0/root. Setting ownership to root:root..."
    sudo chown root:root /etc/ssh/sshd_config
fi

# Set ownership and permissions on the private SSH host key files
echo "Setting ownership and permissions on the private SSH host key files..."
sudo find /etc/ssh -xdev -type f -name 'ssh_host_*_key' -exec chown root:root {} \;
sudo find /etc/ssh -xdev -type f -name 'ssh_host_*_key' -exec chmod 0600 {} \;

echo "Ownership and permissions have been set on the private SSH host key files."
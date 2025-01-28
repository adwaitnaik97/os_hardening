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
    echo "Please install the openssh-server package."
    exit 1
fi

# Check if ignorHosts is set
if [[ $(sshd -T | grep ignorerhosts) ]]; then
    echo "IgnoreRhosts is set to yes."
else
    echo "IgnoreRhosts is not set to yes."
    exit 1
fi

# Edit the sshd_config file
if grep -q "^IgnoreRhosts" /etc/ssh/sshd_config; then
    sudo sed -i "s/^IgnoreRhosts.*/IgnoreRhosts yes/" /etc/ssh/sshd_config
else
    echo "IgnoreRhosts yes" | sudo tee -a /etc/ssh/sshd_config
fi
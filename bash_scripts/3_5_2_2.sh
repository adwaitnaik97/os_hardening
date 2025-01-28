#! /bin/bash

# Check if the system is Ubuntu 18.04 LTS
if [[ $(lsb_release -rs) == "18.04" && $(lsb_release -is) == "Ubuntu" ]]; then
    echo "The system is Ubuntu 18.04 LTS."
else
    echo "The system is not Ubuntu 18.04 LTS."
    exit 1
fi

# Check ufw status
if [[ $(systemctl is-enabled ufw) == "enabled" && $(sudo ufw status verbose) ]]; then
    echo "The ufw is enabled and active."
else
    echo "The ufw is disabled and in-active."
    echo "Enabling ufw..."
    sudo ufw enable
    echo "The ufw is enabled and active."
    echo "Setting the default deny policy...."
    sudo ufw default deny incoming
    sudo ufw default deny outgoing
    sudo ufw default deny routed
    echo "The default deny policy is set."    
fi

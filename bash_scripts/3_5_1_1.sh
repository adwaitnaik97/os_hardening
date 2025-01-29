#! /bin/bash

# Check if the system is Ubuntu 18.04 LTS
if [[ $(lsb_release -rs) == "18.04" && $(lsb_release -is) == "Ubuntu" ]]; then
    echo "The system is Ubuntu 18.04 LTS."
else
    echo "The system is not Ubuntu 18.04 LTS."
    exit 1
fi

# Check if any one of the firewall packages are installed
echo "Checking if any one of the firewall packages are installed..."
if [[ $(dpkg-query -l | grep -E "nftablesd|ufw|iptables") ]]; then
    echo "At least one of the firewall packages is installed."
else
    echo "None of the firewall packages are installed."
    echo "Installing ufw..."
    sudo apt install ufw
    echo "The ufw is installed."
    echo "Installing iptables..."
    sudo apt install iptables
    echo "The iptables is installed."
    echo "Installing nftables..."
    sudo apt install nftables
    echo "The nftables is installed."
fi
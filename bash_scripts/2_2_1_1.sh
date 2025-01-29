#!/bin/bash

# Check if the system is Ubuntu 18.04 LTS
if [[ $(lsb_release -rs) == "18.04" && $(lsb_release -is) == "Ubuntu" ]]; then
    echo "The system is Ubuntu 18.04 LTS."
else
    echo "The system is not Ubuntu 18.04 LTS."
    exit 1
fi

# Check if systemd-timesyncd is used
if [[ $(systemctl is-enabled systemd-timesyncd) == "enabled" ]]; then
    echo "systemd-timesyncd is enabled."
else
    echo "systemd-timesyncd is not enabled."
    exit 1
fi

# Check if chrony or ntp is installed
if [[ $(dpkg -l | grep chrony | wc -l) -eq 1 || $(dpkg -l | grep ntp | wc -l) -eq 1 ]]; then
    echo "chrony or ntp is installed."
else
    echo "chrony or ntp is not installed."
    sudo apt install chrony
    sudo apt install ntp
fi
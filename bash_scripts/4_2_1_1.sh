#!/bin/bash

# Check if the system is Ubuntu 18.04 LTS
if [[ $(lsb_release -rs) != "18.04" || $(lsb_release -is) != "Ubuntu" ]]; then
    echo "The system is not Ubuntu 18.04 LTS."
    exit 1
fi

# Verify either rsyslog or syslog-ng is installed
echo "Verifying if either rsyslog or syslog-ng is installed..."
if dpkg -s rsyslog &> /dev/null || dpkg -s syslog-ng &> /dev/null; then
    echo "Either rsyslog or syslog-ng is installed."
else
    echo "Neither rsyslog nor syslog-ng is installed. Installing rsyslog..."
    sudo apt install -y rsyslog
    echo "rsyslog has been installed."
fi
#!/bin/bash

# Check if the system is Ubuntu 18.04 LTS
if [[ $(lsb_release -rs) != "18.04" || $(lsb_release -is) != "Ubuntu" ]]; then
    echo "The system is not Ubuntu 18.04 LTS."
    exit 1
fi

# Verify the "hard core" setting in /etc/security/limits.conf and /etc/security/limits.d/*
echo "Verifying the 'hard core' setting..."
grep_output=$(grep "hard core" /etc/security/limits.conf /etc/security/limits.d/*)

if echo "$grep_output" | grep -q "\* hard core 0"; then
    echo "'hard core' setting is correct."
else
    echo "'hard core' setting is not correct. Updating the configuration..."
    echo "* hard core 0" | sudo tee -a /etc/security/limits.conf
    echo "'hard core' setting has been updated."
fi

# Verify the fs.suid_dumpable setting
echo "Verifying the fs.suid_dumpable setting..."
sysctl_output=$(sysctl fs.suid_dumpable)
sysctl_conf_output=$(grep "fs\.suid_dumpable" /etc/sysctl.conf /etc/sysctl.d/*)

if [[ "$sysctl_output" == "fs.suid_dumpable = 0" && "$sysctl_conf_output" == *"fs.suid_dumpable = 0"* ]]; then
    echo "fs.suid_dumpable setting is correct."
else
    echo "fs.suid_dumpable setting is not correct. Updating the configuration..."
    echo "fs.suid_dumpable = 0" | sudo tee -a /etc/sysctl.conf
    sudo sysctl -w fs.suid_dumpable=0
    echo "fs.suid_dumpable setting has been updated."
fi

# Check if systemd-coredump is installed
echo "Checking if systemd-coredump is installed..."
coredump_status=$(systemctl is-enabled coredump.service 2>/dev/null)

if [[ "$coredump_status" == "enabled" || "$coredump_status" == "disabled" ]]; then
    echo "systemd-coredump is installed. Updating the configuration..."
    sudo sed -i 's/^#Storage=.*/Storage=none/' /etc/systemd/coredump.conf
    sudo sed -i 's/^#ProcessSizeMax=.*/ProcessSizeMax=0/' /etc/systemd/coredump.conf
    echo "Storage=none" | sudo tee -a /etc/systemd/coredump.conf
    echo "ProcessSizeMax=0" | sudo tee -a /etc/systemd/coredump.conf
    sudo systemctl daemon-reload
    echo "systemd-coredump configuration has been updated."
else
    echo "systemd-coredump is not installed."
fi

# Verify the updated settings
echo "Verifying the updated settings..."
grep "hard core" /etc/security/limits.conf /etc/security/limits.d/*
sysctl fs.suid_dumpable
grep "fs\.suid_dumpable" /etc/sysctl.conf /etc/sysctl.d/*
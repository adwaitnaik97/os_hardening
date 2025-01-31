#!/bin/bash

# Check if the system is Ubuntu 18.04 LTS
if [[ $(lsb_release -rs) != "18.04" || $(lsb_release -is) != "Ubuntu" ]]; then
    echo "The system is not Ubuntu 18.04 LTS."
    exit 1
fi

# Ensure /etc/cron.deny and /etc/at.deny do not exist
echo "Checking if /etc/cron.deny and /etc/at.deny exist..."
if [[ -e /etc/cron.deny ]]; then
    echo "/etc/cron.deny exists. Removing..."
    sudo rm /etc/cron.deny
    echo "/etc/cron.deny has been removed."
else
    echo "/etc/cron.deny does not exist."
fi

if [[ -e /etc/at.deny ]]; then
    echo "/etc/at.deny exists. Removing..."
    sudo rm /etc/at.deny
    echo "/etc/at.deny has been removed."
else
    echo "/etc/at.deny does not exist."
fi

# Verify and set permissions and ownership for /etc/cron.allow
echo "Verifying /etc/cron.allow..."
if [[ -e /etc/cron.allow ]]; then
    cron_allow_info=$(stat /etc/cron.allow)
    cron_allow_uid=$(echo "$cron_allow_info" | grep "Uid:" | awk '{print $4}')
    cron_allow_gid=$(echo "$cron_allow_info" | grep "Gid:" | awk '{print $4}')
    cron_allow_perms=$(stat -c "%a" /etc/cron.allow)

    if [[ "$cron_allow_uid" == "0" && "$cron_allow_gid" == "0" && "$cron_allow_perms" == "640" ]]; then
        echo "/etc/cron.allow has the correct permissions and ownership."
    else
        echo "/etc/cron.allow does not have the correct permissions and ownership. Updating..."
        sudo chmod o-rwx /etc/cron.allow
        sudo chmod g-wx /etc/cron.allow
        sudo chown root:root /etc/cron.allow
        echo "/etc/cron.allow permissions and ownership have been updated."
        stat /etc/cron.allow
    fi
else
    echo "/etc/cron.allow does not exist. Creating and setting permissions and ownership..."
    sudo touch /etc/cron.allow
    sudo chmod o-rwx /etc/cron.allow
    sudo chmod g-wx /etc/cron.allow
    sudo chown root:root /etc/cron.allow
    echo "/etc/cron.allow has been created and configured."
    stat /etc/cron.allow
fi

# Verify and set permissions and ownership for /etc/at.allow
echo "Verifying /etc/at.allow..."
if [[ -e /etc/at.allow ]]; then
    at_allow_info=$(stat /etc/at.allow)
    at_allow_uid=$(echo "$at_allow_info" | grep "Uid:" | awk '{print $4}')
    at_allow_gid=$(echo "$at_allow_info" | grep "Gid:" | awk '{print $4}')
    at_allow_perms=$(stat -c "%a" /etc/at.allow)

    if [[ "$at_allow_uid" == "0" && "$at_allow_gid" == "0" && "$at_allow_perms" == "640" ]]; then
        echo "/etc/at.allow has the correct permissions and ownership."
    else
        echo "/etc/at.allow does not have the correct permissions and ownership. Updating..."
        sudo chmod o-rwx /etc/at.allow
        sudo chmod g-wx /etc/at.allow
        sudo chown root:root /etc/at.allow
        echo "/etc/at.allow permissions and ownership have been updated."
        stat /etc/at.allow
    fi
else
    echo "/etc/at.allow does not exist. Creating and setting permissions and ownership..."
    sudo touch /etc/at.allow
    sudo chmod o-rwx /etc/at.allow
    sudo chmod g-wx /etc/at.allow
    sudo chown root:root /etc/at.allow
    echo "/etc/at.allow has been created and configured."
    stat /etc/at.allow
fi
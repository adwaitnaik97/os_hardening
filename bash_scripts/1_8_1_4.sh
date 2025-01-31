#!/bin/bash

# Check if the system is Ubuntu 18.04 LTS
if [[ $(lsb_release -rs) != "18.04" || $(lsb_release -is) != "Ubuntu" ]]; then
    echo "The system is not Ubuntu 18.04 LTS."
    exit 1
fi

# Verify Uid and Gid are both 0/root and Access is 644 for /etc/motd
echo "Verifying Uid and Gid are both 0/root and Access is 644 for /etc/motd..."
file_info=$(stat /etc/motd)
uid=$(echo "$file_info" | grep "Uid:" | awk '{print $4}')
gid=$(echo "$file_info" | grep "Gid:" | awk '{print $4}')
permissions=$(stat -c "%a" /etc/motd)

if [[ "$uid" == "0" && "$gid" == "0" && "$permissions" == "644" ]]; then
    echo "The Uid and Gid are both 0/root and Access is 644 for /etc/motd."
else
    echo "The Uid and Gid are not 0/root or Access is not 644 for /etc/motd. Updating the permissions..."
    sudo chown root:root /etc/motd
    sudo chmod u-x,go-wx /etc/motd
    echo "Permissions have been updated for /etc/motd."
fi

# Verify the updated permissions
echo "Verifying the updated permissions for /etc/motd..."
sudo stat /etc/motd
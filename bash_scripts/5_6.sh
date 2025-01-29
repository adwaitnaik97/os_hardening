#!/bin/bash

# Check if the system is Ubuntu 18.04 LTS
if [[ $(lsb_release -rs) != "18.04" || $(lsb_release -is) != "Ubuntu" ]]; then
    echo "The system is not Ubuntu 18.04 LTS."
    exit 1
fi

# Verify the pam_wheel.so configuration in /etc/pam.d/su
echo "Verifying pam_wheel.so configuration in /etc/pam.d/su..."
pam_wheel_config=$(grep pam_wheel.so /etc/pam.d/su)

if echo "$pam_wheel_config" | grep -q "auth required pam_wheel.so use_uid group="; then
    echo "pam_wheel.so configuration is correct: $pam_wheel_config"
else
    echo "pam_wheel.so configuration is not correct. Updating the configuration..."
    sudo groupadd sugroup
    echo "auth required pam_wheel.so use_uid group=sugroup" | sudo tee -a /etc/pam.d/su
    echo "pam_wheel.so configuration has been updated."
fi

# Extract the group name from the pam_wheel.so configuration
group_name=$(echo "$pam_wheel_config" | grep -oP 'group=\K\w+')

# Verify that the group specified in <group_name> contains no users
echo "Verifying that the group $group_name contains no users..."
group_info=$(grep "^$group_name:" /etc/group)

if [[ "$group_info" == "$group_name:x:*:" ]]; then
    echo "The group $group_name contains no users."
else
    echo "The group $group_name contains users or does not exist. Creating an empty group and updating the configuration..."
    sudo groupadd sugroup
    sudo sed -i 's/^auth required pam_wheel.so use_uid group=.*/auth required pam_wheel.so use_uid group=sugroup/' /etc/pam.d/su
    echo "The group sugroup has been created and the configuration has been updated."
fi

# Verify the updated configuration
echo "Verifying the updated configuration..."
grep pam_wheel.so /etc/pam.d/su
grep sugroup /etc/group
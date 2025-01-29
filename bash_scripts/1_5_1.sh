#! /bin/bash

# Check if the system is Ubuntu 18.04 LTS
if [[ $(lsb_release -rs) == "18.04" && $(lsb_release -is) == "Ubuntu" ]]; then
    echo "The system is Ubuntu 18.04 LTS."
else
    echo "The system is not Ubuntu 18.04 LTS."
    exit 1
fi

# Check if the bootloader is configured with appropriate permissions
file_info=$(stat /boot/grub/grub.cfg)
uid=$(echo "$file_info" | grep "Uid:" | awk '{print $4}')
gid=$(echo "$file_info" | grep "Gid:" | awk '{print $4}')
permissions=$(stat -c "%a" /boot/grub/grub.cfg)

if [[ "$uid" == "0" && "$gid" == "0" && "$permissions" == "600" ]]; then
    echo "The bootloader is configured with appropriate permissions."
else
    echo "The bootloader is not configured with appropriate permissions."
    echo "Configuring the bootloader with appropriate permissions..."
    sudo chown root:root /boot/grub/grub.cfg
    sudo chmod og-rwx /boot/grub/grub.cfg
    echo "Permissions have been updated."
fi
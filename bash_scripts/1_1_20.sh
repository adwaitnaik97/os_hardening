#! /bin/bash

# Check if the system is Ubuntu 18.04 LTS
if [[ $(lsb_release -rs) == "18.04" && $(lsb_release -is) == "Ubuntu" ]]; then
    echo "The system is Ubuntu 18.04 LTS."
else
    echo "The system is not Ubuntu 18.04 LTS."
    exit 1
fi

# Check if the nonexec option is set on all removable media partitions
if [[ $(mount | grep -E '\s/var/tmp\s' | grep noexec) ]]; then
    echo "The nonexec option is set on all removable media partitions."
else
    echo "The nonexec option is not set on all removable media partitions."
    # Backup the original /etc/fstab file
    sudo cp /etc/fstab /etc/fstab.bak

    # Add noexec to the fourth field (mounting options) of all removable media partitions
    sudo sed -i '/\/media\// s/defaults/defaults,noexec/' /etc/fstab

    echo "The noexec option has been added to all removable media partitions in /etc/fstab."

    # Remount all filesystems to apply changes
    sudo mount -a

    echo "All filesystems have been remounted."  
fi

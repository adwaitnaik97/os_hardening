#! /bin/bash

# Check if the system is Ubuntu 18.04 LTS
if [[ $(lsb_release -rs) == "18.04" && $(lsb_release -is) == "Ubuntu" ]]; then
    echo "The system is Ubuntu 18.04 LTS."
else
    echo "The system is not Ubuntu 18.04 LTS."
    exit 1
fi

# Verify that all linux lines have the apparmor=1 parameter set
grep "^\s*linux" /boot/grub/grub.cfg | grep -v "apparmor=1" | grep -v '/boot/memtest86+.bin'

# Verify that all linux lines have the security=apparmor parameter set
grep "^\s*linux" /boot/grub/grub.cfg | grep -v "security=apparmor" | grep -v '/boot/memtest86+.bin'

# Backup the original /etc/default/grub file
echo "Creating a backup file first....."
sudo cp /etc/default/grub /etc/default/grub.bak

# Add the apparmor=1 and security=apparmor parameters to the GRUB_CMDLINE_LINUX line
sudo sed -i 's/\(GRUB_CMDLINE_LINUX="[^"]*\)/\1 apparmor=1 security=apparmor/' /etc/default/grub

# Update GRUB configuration
sudo update-grub

# Verify that all linux lines have the apparmor=1 parameter set
if grep "^\s*linux" /boot/grub/grub.cfg | grep -v "apparmor=1" | grep -v '/boot/memtest86+.bin'; then
    echo "Error: Some linux lines do not have the apparmor=1 parameter set."
else
    echo "All linux lines have the apparmor=1 parameter set."
fi

# Verify that all linux lines have the security=apparmor parameter set
if grep "^\s*linux" /boot/grub/grub.cfg | grep -v "security=apparmor" | grep -v '/boot/memtest86+.bin'; then
    echo "Error: Some linux lines do not have the security=apparmor parameter set."
else
    echo "All linux lines have the security=apparmor parameter set."
fi
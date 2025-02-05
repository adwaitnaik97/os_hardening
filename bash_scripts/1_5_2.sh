#!/bin/bash

# Check if the system is Ubuntu 18.04 LTS
if [[ $(lsb_release -rs) == "18.04" && $(lsb_release -is) == "Ubuntu" ]]; then
    echo "The system is Ubuntu 18.04 LTS."
else
    echo "The system is not Ubuntu 18.04 LTS."
    exit 1
fi

# Define the expected patterns
expected_superusers="set superusers=\"<username>\""  # Replace <username> with the actual expected username
expected_password="password_pbkdf2 <username> <encrypted-password>"  # Replace <username> and <encrypted-password> with actual values

# Check if the superusers and password lines match the expected patterns
if sudo grep "^set superusers" /boot/grub/grub.cfg && sudo grep "^password" /boot/grub/grub.cfg; then
    actual_superusers=$(sudo grep "^set superusers" /boot/grub/grub.cfg)
    actual_password=$(sudo grep "^password" /boot/grub/grub.cfg)
    echo "Output of 'sudo grep \"^set superusers\" /boot/grub/grub.cfg':"
    echo "$actual_superusers"
    echo "Output of 'sudo grep \"^password\" /boot/grub/grub.cfg':"
    echo "$actual_password"
    if [[ "$actual_superusers" == "$expected_superusers" && "$actual_password" == "$expected_password" ]]; then
        echo "The superusers and password lines match the expected patterns."
    else
        echo "The superusers or password lines do not match the expected patterns."
        echo "Expected superusers: $expected_superusers"
        echo "Actual superusers: $actual_superusers"
        echo "Expected password: $expected_password"
        echo "Actual password: $actual_password"
        exit 1
    fi
else
    # echo "The superusers or password lines are not found in /boot/grub/grub.cfg."
    # Prompt for the username
    # read -p "Enter the username for GRUB superuser: " username

    # Generate the encrypted password
    echo "Generating the encrypted password..."
    grub-mkpasswd-pbkdf2

    # Create a custom GRUB configuration file
    echo "Creating a custom GRUB configuration file..."
    custom_grub_file="/etc/grub.d/40_custom_user"
    sudo bash -c "cat <<EOF > $custom_grub_file
    set superusers=\"$username\"
    password_pbkdf2 $username $encrypted_password
    EOF"

    # Ensure the custom GRUB configuration file is executable
    sudo chmod +x $custom_grub_file

    # Optionally, add --unrestricted to /etc/grub.d/10_linux
    sudo sed -i 's/^\(CLASS=".*\)"/\1 --unrestricted"/' /etc/grub.d/10_linux

    # Update the GRUB configuration
    echo "Updating the GRUB configuration..."
    sudo update-grub

    echo "GRUB superuser configuration has been updated."

fi
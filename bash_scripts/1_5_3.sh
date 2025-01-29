#! /bin/bash

# Check if the system is Ubuntu 18.04 LTS
if [[ $(lsb_release -rs) == "18.04" && $(lsb_release -is) == "Ubuntu" ]]; then
    echo "The system is Ubuntu 18.04 LTS."
else
    echo "The system is not Ubuntu 18.04 LTS."
    exit 1
fi

# Check if the password is set for the root user
if sudo grep ^root:[*\!]: /etc/shadow; then
    echo "The password is set for the root user."
else
    echo "The password is not set for the root user."
    echo "Setting the password for the root user..."
    sudo passwd root
    echo "Password has been set."
fi
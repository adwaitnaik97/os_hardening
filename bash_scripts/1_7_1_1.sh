#! /bin/bash

# Check if the system is Ubuntu 18.04 LTS
if [[ $(lsb_release -rs) == "18.04" && $(lsb_release -is) == "Ubuntu" ]]; then
    echo "The system is Ubuntu 18.04 LTS."
else
    echo "The system is not Ubuntu 18.04 LTS."
    exit 1
fi

# Check if AppArmor is installed
if [[ $(dpkg -l | grep apparmor) ]]; then
    echo "AppArmor is installed."
    sudo apparmor_status
else
    echo "AppArmor is not installed."
    echo "Installing it now ....."
    sudo apt install apparmor-profiles
fi
#! /bin/bash

# Check if the system is Ubuntu 18.04 LTS
if [[ $(lsb_release -rs) == "18.04" && $(lsb_release -is) == "Ubuntu" ]]; then
    echo "The system is Ubuntu 18.04 LTS."
else
    echo "The system is not Ubuntu 18.04 LTS."
    exit 1
fi

# Check if AppArmor is enabled
if systemctl is-enabled apparmor | grep -q "enabled" && apparmor_status | grep -q "apparmor module is loaded"; then
    echo "AppArmor is enabled."
    sudo apparmor_status | grep profiles
    sudo apparmor_status | grep processes

    # If the profiles are not in enforce or complain mode then set them to enforce mode
    echo "Setting AppArmor profiles to enforce or complain mode..."
    sudo aa-enforce /etc/apparmor.d/*  || sudo aa-complain /etc/apparmor.d/*
    echo "AppArmor profiles have been set to enforce or complain mode."

    # If the processes are not in enforce or complain mode then set them to enforce mode
    echo "Setting AppArmor processes to enforce or complain mode..."
    sudo aa-enforce /etc/apparmor.d/abstractions/* || sudo aa-complain /etc/apparmor.d/abstractions/*
    echo "AppArmor processes have been set to enforce or complain mode."

else
    echo "AppArmor is not enabled."
    sudo systemctl enable apparmor
    sudo systemctl start apparmor
    echo "AppArmor has been enabled."
fi
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
else
    echo "AppArmor is not enabled."
    exit 1
fi

# If AppArmor is enabled, check if the AppArmor profiles are enforced
if apparmor_status | grep -q "profiles are in enforce mode"; then
    echo "The AppArmor profiles are enforced."
else
    echo "The AppArmor profiles are not enforced."
    echo "Enforcing the AppArmor profiles..."
    sudo aa-enforce /etc/apparmor.d/*
    exit 1
fi
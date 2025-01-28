#!/bin/bash

# Check if the system is Ubuntu 18.04 LTS
if [[ $(lsb_release -rs) == "18.04" && $(lsb_release -is) == "Ubuntu" ]]; then
    echo "The system is Ubuntu 18.04 LTS."
else
    echo "The system is not Ubuntu 18.04 LTS."
    exit 1
fi

# Check the PermitEmptyPasswords parameter value
if grep -Ei "^\s*PermitEmptyPasswords\s+yes" /etc/ssh/sshd_config; then
    echo "The PermitEmptyPasswords parameter is set to yes. Updating it to no..."
    sudo sed -i 's/^\s*PermitEmptyPasswords\s\+yes/PermitEmptyPasswords no/' /etc/ssh/sshd_config
else
    echo "The PermitEmptyPasswords parameter is not set to yes. Adding it with value no..."
    echo "PermitEmptyPasswords no" | sudo tee -a /etc/ssh/sshd_config
fi

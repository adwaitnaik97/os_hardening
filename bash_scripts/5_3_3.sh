#!/bin/bash

# Check if the system is Ubuntu 18.04 LTS
if [[ $(lsb_release -rs) != "18.04" || $(lsb_release -is) != "Ubuntu" ]]; then
    echo "The system is not Ubuntu 18.04 LTS."
    exit 1
fi

# Verify the remember option in /etc/pam.d/common-password
echo "Checking the remember option in /etc/pam.d/common-password..."
pam_config=$(grep -E '^password\s+required\s+pam_pwhistory.so' /etc/pam.d/common-password)

if echo "$pam_config" | grep -q "remember=[5-9]\|remember=[1-9][0-9]"; then
    echo "The remember option is set to 5 or more."
else
    echo "The remember option is not set to 5 or more. Updating the configuration..."
    if grep -qE '^password\s+required\s+pam_pwhistory.so' /etc/pam.d/common-password; then
        sudo sed -i 's/\(^password\s\+required\s\+pam_pwhistory.so.*\)/\1 remember=5/' /etc/pam.d/common-password
    else
        echo "password required pam_pwhistory.so remember=5" | sudo tee -a /etc/pam.d/common-password
    fi
    echo "The remember option has been set to 5 in /etc/pam.d/common-password."
fi

# Verify the updated configuration
echo "Verifying the updated configuration..."
grep -E '^password\s+required\s+pam_pwhistory.so' /etc/pam.d/common-password
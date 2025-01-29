#!/bin/bash

# Check if the system is Ubuntu 18.04 LTS
if [[ $(lsb_release -rs) != "18.04" || $(lsb_release -is) != "Ubuntu" ]]; then
    echo "The system is not Ubuntu 18.04 LTS."
    exit 1
fi

# Verify the minimum password length
echo "Verifying the minimum password length..."
minlen=$(grep '^\s*minlen\s*' /etc/security/pwquality.conf | awk -F= '{print $2}' | tr -d ' ')

if [[ -n "$minlen" && "$minlen" -ge 14 ]]; then
    echo "The minimum password length is set to $minlen characters."
else
    echo "The minimum password length is not set to 14 or more characters. Updating the configuration..."
    if grep -q '^\s*minlen\s*' /etc/security/pwquality.conf; then
        sudo sed -i 's/^\s*minlen\s*=.*/minlen = 14/' /etc/security/pwquality.conf
    else
        echo "minlen = 14" | sudo tee -a /etc/security/pwquality.conf
    fi
    echo "The minimum password length has been set to 14 characters."
fi

# Verify the required password complexity
echo "Verifying the required password complexity..."
minclass=$(grep '^\s*minclass\s*' /etc/security/pwquality.conf | awk -F= '{print $2}' | tr -d ' ')

if [[ -n "$minclass" && "$minclass" -ge 4 ]]; then
    echo "The required password complexity is set to $minclass classes."
else
    echo "The required password complexity is not set to 4 classes. Updating the configuration..."
    if grep -q '^\s*minclass\s*' /etc/security/pwquality.conf; then
        sudo sed -i 's/^\s*minclass\s*=.*/minclass = 4/' /etc/security/pwquality.conf
    else
        echo "minclass = 4" | sudo tee -a /etc/security/pwquality.conf
    fi
    echo "The required password complexity has been set to 4 classes."
fi

# Verify the updated configuration
echo "Verifying the updated configuration..."
grep '^\s*minlen\s*' /etc/security/pwquality.conf
grep '^\s*minclass\s*' /etc/security/pwquality.conf
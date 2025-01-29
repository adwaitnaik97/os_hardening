#!/bin/bash

# Check if the system is Ubuntu 18.04 LTS
if [[ $(lsb_release -rs) != "18.04" || $(lsb_release -is) != "Ubuntu" ]]; then
    echo "The system is not Ubuntu 18.04 LTS."
    exit 1
fi

# Verify dcredit, ucredit, lcredit, and ocredit settings
echo "Verifying dcredit, ucredit, lcredit, and ocredit settings in /etc/security/pwquality.conf..."
grep_output=$(grep -E '^\s*[duol]credit\s*' /etc/security/pwquality.conf)

expected_settings="dcredit = -1
ucredit = -1
lcredit = -1
ocredit = -1"

if [[ "$grep_output" == "$expected_settings" ]]; then
    echo "The dcredit, ucredit, lcredit, and ocredit settings are correct."
else
    echo "The dcredit, ucredit, lcredit, and ocredit settings are not correct. Updating the configuration..."
    sudo sed -i 's/^\s*dcredit\s*=.*/dcredit = -1/' /etc/security/pwquality.conf
    sudo sed -i 's/^\s*ucredit\s*=.*/ucredit = -1/' /etc/security/pwquality.conf
    sudo sed -i 's/^\s*lcredit\s*=.*/lcredit = -1/' /etc/security/pwquality.conf
    sudo sed -i 's/^\s*ocredit\s*=.*/ocredit = -1/' /etc/security/pwquality.conf
    echo "The dcredit, ucredit, lcredit, and ocredit settings have been updated."
fi

# Verify the number of attempts allowed before sending back a failure
echo "Verifying the number of attempts allowed before sending back a failure in /etc/pam.d/common-password..."
retry_output=$(grep -E '^\s*password\s+(requisite|required)\s+pam_pwquality\.so\s+(\S+\s+)*retry=[1-3]\s*(\s+\S+\s*)*(\s+#.*)?$' /etc/pam.d/common-password)

if [[ -n "$retry_output" ]]; then
    echo "The number of attempts allowed before sending back a failure is set correctly."
else
    echo "The number of attempts allowed before sending back a failure is not set correctly. Updating the configuration..."
    if grep -qE '^\s*password\s+(requisite|required)\s+pam_pwquality\.so' /etc/pam.d/common-password; then
        sudo sed -i 's/^\s*password\s\+\(requisite\|required\)\s\+pam_pwquality\.so\s\+\(\S\+\s\+\)*retry=[0-9]\+\(\s\+\S\+\s*\)*\(\s*#.*\)\?$/password \1 pam_pwquality.so \2 retry=3 \3 \4/' /etc/pam.d/common-password
    else
        echo "password requisite pam_pwquality.so retry=3" | sudo tee -a /etc/pam.d/common-password
    fi
    echo "The number of attempts allowed before sending back a failure has been set to 3."
fi

# Verify the updated configuration
echo "Verifying the updated configuration..."
grep -E '^\s*[duol]credit\s*' /etc/security/pwquality.conf
grep -E '^\s*password\s+(requisite|required)\s+pam_pwquality\.so\s+(\S+\s+)*retry=[1-3]\s*(\s+\S+\s*)*(\s+#.*)?$' /etc/pam.d/common-password
#!/bin/bash

# Check if the system is Ubuntu 18.04 LTS
if [[ $(lsb_release -rs) != "18.04" || $(lsb_release -is) != "Ubuntu" ]]; then
    echo "The system is not Ubuntu 18.04 LTS."
    exit 1
fi

# Ensure the password hashing algorithm is SHA-512
echo "Ensuring the password hashing algorithm is SHA-512..."
grep_output=$(grep -E '^\s*password\s+(\S+\s+)+pam_unix\.so\s+(\S+\s+)*sha512\s*(\S+\s*)*(\s+#.*)?$' /etc/pam.d/common-password)

if [[ -n "$grep_output" ]]; then
    echo "The sha512 option is included in the results:"
    echo "$grep_output"
else
    echo "The sha512 option is not included in the results. Updating the configuration..."
    if grep -qE '^\s*password\s+(\S+\s+)+pam_unix\.so' /etc/pam.d/common-password; then
        sudo sed -i 's/^\s*password\s\+\(\S\+\s\+\)\+pam_unix\.so\s\+\(\S\+\s\+\)*\(sha512\s*\)\?\(\S\+\s*\)*\(\s*#.*\)\?$/password \1 pam_unix.so \2 sha512 \4 \5/' /etc/pam.d/common-password
    else
        echo "password [success=1 default=ignore] pam_unix.so sha512" | sudo tee -a /etc/pam.d/common-password
    fi
    echo "The sha512 option has been added to /etc/pam.d/common-password."
fi

# Verify the updated configuration
echo "Verifying the updated configuration..."
grep -E '^\s*password\s+(\S+\s+)+pam_unix\.so\s+(\S+\s+)*sha512\s*(\S+\s*)*(\s+#.*)?$' /etc/pam.d/common-password
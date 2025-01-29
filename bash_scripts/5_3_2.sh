#!/bin/bash

# Check if the system is Ubuntu 18.04 LTS
if [[ $(lsb_release -rs) != "18.04" || $(lsb_release -is) != "Ubuntu" ]]; then
    echo "The system is not Ubuntu 18.04 LTS."
    exit 1
fi

# Verify the password lockouts are configured with pam_tally2.so in /etc/pam.d/common-auth
echo "Verifying password lockouts are configured with pam_tally2.so in /etc/pam.d/common-auth..."
if grep -qE "auth[[:space:]]+required[[:space:]]+pam_tally2.so" /etc/pam.d/common-auth; then
    echo "The password lockouts are configured with pam_tally2.so in /etc/pam.d/common-auth."
else
    echo "The password lockouts are not configured with pam_tally2.so in /etc/pam.d/common-auth. Updating the configuration..."
    echo "auth required pam_tally2.so onerr=fail audit silent deny=5 unlock_time=900" | sudo tee -a /etc/pam.d/common-auth
    echo "The password lockouts have been configured with pam_tally2.so in /etc/pam.d/common-auth."
fi

# Verify pam_deny.so and pam_tally2.so modules are included in /etc/pam.d/common-account
echo "Verifying pam_deny.so and pam_tally2.so modules are included in /etc/pam.d/common-account..."
if grep -qE "account[[:space:]]+requisite[[:space:]]+pam_deny.so" /etc/pam.d/common-account && grep -qE "account[[:space:]]+required[[:space:]]+pam_tally2.so" /etc/pam.d/common-account; then
    echo "The pam_deny.so and pam_tally2.so modules are included in /etc/pam.d/common-account."
else
    echo "The pam_deny.so and pam_tally2.so modules are not included in /etc/pam.d/common-account. Updating the configuration..."
    echo "account requisite pam_deny.so" | sudo tee -a /etc/pam.d/common-account
    echo "account required pam_tally2.so" | sudo tee -a /etc/pam.d/common-account
    echo "The pam_deny.so and pam_tally2.so modules have been included in /etc/pam.d/common-account."
fi

# Verify the updated configuration
echo "Verifying the updated configuration..."
grep -E "auth[[:space:]]+required[[:space:]]+pam_tally2.so" /etc/pam.d/common-auth
grep -E "account[[:space:]]+requisite[[:space:]]+pam_deny.so" /etc/pam.d/common-account
grep -E "account[[:space:]]+required[[:space:]]+pam_tally2.so" /etc/pam.d/common-account
#!/bin/bash

# Check if the system is Ubuntu 18.04 LTS
if [[ $(lsb_release -rs) == "18.04" && $(lsb_release -is) == "Ubuntu" ]]; then
    echo "The system is Ubuntu 18.04 LTS."
else
    echo "The system is not Ubuntu 18.04 LTS."
    exit 1
fi

# Verify PASS_MAX_DAYS in /etc/login.defs
echo "Checking PASS_MAX_DAYS in /etc/login.defs..."
pass_max_days=$(grep "^PASS_MAX_DAYS" /etc/login.defs | awk '{print $2}')
if [[ -n "$pass_max_days" && "$pass_max_days" -le 365 ]]; then
    echo "PASS_MAX_DAYS in /etc/login.defs is set to $pass_max_days and conforms to site policy."
else
    echo "PASS_MAX_DAYS in /etc/login.defs does not conform to site policy. Setting it to 365..."
    sudo sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS 365/' /etc/login.defs
    echo "PASS_MAX_DAYS has been set to 365 in /etc/login.defs."
fi

# Review list of users and their PASS_MAX_DAYS
echo "Reviewing list of users and their PASS_MAX_DAYS..."
user_pass_max_days=$(grep -E '^[^:]+:[^!*]' /etc/shadow | cut -d: -f1,5)

echo "Users and their PASS_MAX_DAYS:"
echo "$user_pass_max_days"

# Check if any user has PASS_MAX_DAYS greater than 365
non_compliant_users=$(echo "$user_pass_max_days" | awk -F: '$2 > 365 {print $1}')
if [[ -n "$non_compliant_users" ]]; then
    echo "The following users have PASS_MAX_DAYS greater than 365 and do not conform to site policy:"
    echo "$non_compliant_users"
    echo "Updating PASS_MAX_DAYS to 365 for these users..."
    for user in $non_compliant_users; do
        sudo chage --maxdays 365 "$user"
    done
    echo "PASS_MAX_DAYS has been updated to 365 for the non-compliant users."
else
    echo "All users' PASS_MAX_DAYS conform to site policy."
fi
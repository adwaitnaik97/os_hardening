#!/bin/bash

# Check if the system is Ubuntu 18.04 LTS
if [[ $(lsb_release -rs) == "18.04" && $(lsb_release -is) == "Ubuntu" ]]; then
    echo "The system is Ubuntu 18.04 LTS."
else
    echo "The system is not Ubuntu 18.04 LTS."
    exit 1
fi

# Verify PASS_MIN_DAYS in /etc/login.defs
echo "Checking PASS_MIN_DAYS in /etc/login.defs..."
pass_min_days=$(grep "^PASS_MIN_DAYS" /etc/login.defs | awk '{print $2}')
if [[ -n "$pass_min_days" && "$pass_min_days" -ge 1 ]]; then
    echo "PASS_MIN_DAYS in /etc/login.defs is set to $pass_min_days and conforms to site policy."
else
    echo "PASS_MIN_DAYS in /etc/login.defs does not conform to site policy. Setting it to 1..."
    sudo sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS 1/' /etc/login.defs
    echo "PASS_MIN_DAYS has been set to 1 in /etc/login.defs."
fi

# Review list of users and their PASS_MIN_DAYS
echo "Reviewing list of users and their PASS_MIN_DAYS..."
user_pass_min_days=$(grep -E '^[^:]+:[^!*]' /etc/shadow | cut -d: -f1,4)

echo "Users and their PASS_MIN_DAYS:"
echo "$user_pass_min_days"

# Check if any user has PASS_MIN_DAYS less than 1
non_compliant_users=$(echo "$user_pass_min_days" | awk -F: '$2 < 1 {print $1}')
if [[ -n "$non_compliant_users" ]]; then
    echo "The following users have PASS_MIN_DAYS less than 1 and do not conform to site policy:"
    echo "$non_compliant_users"
    echo "Updating PASS_MIN_DAYS to 1 for these users..."
    for user in $non_compliant_users; do
        sudo chage --mindays 1 "$user"
    done
    echo "PASS_MIN_DAYS has been updated to 1 for the non-compliant users."
else
    echo "All users' PASS_MIN_DAYS conform to site policy."
fi
#!/bin/bash

# Check if the system is Ubuntu 18.04 LTS
if [[ $(lsb_release -rs) != "18.04" || $(lsb_release -is) != "Ubuntu" ]]; then
    echo "The system is not Ubuntu 18.04 LTS."
    exit 1
fi

# Check if any accounts in the /etc/shadow file do not have a password
echo "Checking if any accounts in the /etc/shadow file do not have a password..."
no_password_accounts=$(awk -F: '($2 == "" ) { print $1 }' /etc/shadow)

if [[ -n "$no_password_accounts" ]]; then
    echo "The following accounts do not have a password:"
    echo "$no_password_accounts"
    echo "Locking the accounts without a password..."
    for user in $no_password_accounts; do
        sudo passwd -l "$user"
        echo "Account $user has been locked."
    done
else
    echo "All accounts in the /etc/shadow file have a password."
fi
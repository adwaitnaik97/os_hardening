#!/bin/bash

# Check if the system is Ubuntu 18.04 LTS
if [[ $(lsb_release -rs) == "18.04" && $(lsb_release -is) == "Ubuntu" ]]; then
    echo "The system is Ubuntu 18.04 LTS."
else
    echo "The system is not Ubuntu 18.04 LTS."
    exit 1
fi

# Check if only the `root` account has the superuser privileges
if [[ $(awk -F: '($3 == 0) { print $1 }' /etc/passwd) ]]; then
    echo "Only the 'root' account has the superuser privileges."
else
    echo "The 'root' account does not have the superuser privileges."
    exit 1
fi

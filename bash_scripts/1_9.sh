#!/bin/bash

# Check if the system is Ubuntu 18.04 LTS
if [[ $(lsb_release -rs) == "18.04" && $(lsb_release -is) == "Ubuntu" ]]; then
    echo "The system is Ubuntu 18.04 LTS."
else
    echo "The system is not Ubuntu 18.04 LTS."
    exit 1
fi

# Check if the system is up-to-date
if [[ $(sudo apt list --upgradable 2>/dev/null | wc -l) -le 1 ]]; then
    echo "The system is up-to-date."
else
    echo "The system is not up-to-date."
    sudo apt upgrade
fi
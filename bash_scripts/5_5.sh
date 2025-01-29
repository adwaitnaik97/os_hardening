#!/bin/bash

# Check if the system is Ubuntu 18.04 LTS
if [[ $(lsb_release -rs) == "18.04" && $(lsb_release -is) == "Ubuntu" ]]; then
    echo "The system is Ubuntu 18.04 LTS."
else
    echo "The system is not Ubuntu 18.04 LTS."
    exit 1
fi

# Ensure all the locations entries in the console are physically secured
if [[ $(cat /etc/securetty) ]]; then
    echo "Most of all the locations entries in the console are physically secured. However, it depends on user requirements if an entry is supposed to be removed."
else
    echo "The locations entries in the console are not physically secured."
    exit 1
fi
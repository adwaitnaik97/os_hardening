#! /bin/bash

# Check if the system is Ubuntu 18.04 LTS
if [[ $(lsb_release -rs) == "18.04" && $(lsb_release -is) == "Ubuntu" ]]; then
    echo "The system is Ubuntu 18.04 LTS."
else
    echo "The system is not Ubuntu 18.04 LTS."
    exit 1
fi

# Check if AIDE is installed
if [[ $(dpkg -s aide) ]]; then
    echo "AIDE is installed."
    sudo aideinit
else
    echo "AIDE is not installed."
    echo "Installing AIDE..."
    sudo apt install aide aide-common
    dpkg -s aide
    sudo aideinit
fi
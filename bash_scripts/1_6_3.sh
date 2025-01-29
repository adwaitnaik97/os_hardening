#!/bin/bash

# Check if the system is Ubuntu 18.04 LTS
if [[ $(lsb_release -rs) != "18.04" || $(lsb_release -is) != "Ubuntu" ]]; then
    echo "The system is not Ubuntu 18.04 LTS."
    exit 1
fi

# Verify prelink is not installed
echo "Verifying if prelink is installed..."
if dpkg -s prelink; then
    echo "prelink is installed. Restoring binaries to normal and uninstalling prelink..."
    
    # Restore binaries to normal
    sudo prelink -ua
    
    # Uninstall prelink
    sudo apt purge -y prelink
    
    echo "prelink has been uninstalled."
else
    echo "prelink is not installed."
fi
#!/bin/bash

# Check if the system is Ubuntu 18.04 LTS
if [[ $(lsb_release -rs) != "18.04" || $(lsb_release -is) != "Ubuntu" ]]; then
    echo "The system is not Ubuntu 18.04 LTS."
    exit 1
fi

# Verify either rsyslog or syslog-ng is installed
echo "Verifying if either rsyslog or syslog-ng is installed..."
if dpkg -s rsyslog &> /dev/null || dpkg -s syslog-ng &> /dev/null; then
    echo "Either rsyslog or syslog-ng is installed."
    # Prompt the user to set up rsyslog
    read -p "Do you want to configure rsyslog on your system? (yes/y to proceed): " user_input
    if [[ "$user_input" == "yes" || "$user_input" == "y" ]]; then

        # Open the webpage for further setup instructions
        echo "Opening the webpage for rsyslog setup instructions..."
        
        # Check for available browsers and use the first one found
        if command -v firefox &> /dev/null; then
            sudo -u "$SUDO_USER" firefox "https://www.manageengine.com/products/eventlog/logging-guide/syslog/configuring-ubuntu-lts-as-rsyslog-server.html"
        elif command -v google-chrome &> /dev/null; then
            sudo -u "$SUDO_USER" google-chrome "https://www.manageengine.com/products/eventlog/logging-guide/syslog/configuring-ubuntu-lts-as-rsyslog-server.html"
        elif command -v chromium-browser &> /dev/null; then
            sudo -u "$SUDO_USER" chromium-browser "https://www.manageengine.com/products/eventlog/logging-guide/syslog/configuring-ubuntu-lts-as-rsyslog-server.html"
        elif command -v xdg-open &> /dev/null; then
            sudo -u "$SUDO_USER" xdg-open "https://www.manageengine.com/products/eventlog/logging-guide/syslog/configuring-ubuntu-lts-as-rsyslog-server.html"
        else
            echo "No supported web browser found. Please open the following link manually:"
            echo "https://www.manageengine.com/products/eventlog/logging-guide/syslog/configuring-ubuntu-lts-as-rsyslog-server.html"
        fi
    else
        echo "rsyslog setup was not initiated."
    fi
else
    echo "Neither rsyslog nor syslog-ng is installed."
    echo "Installing rsyslog...."
    sudo apt install rsyslog
fi
#!/bin/bash

# Check if the system is Ubuntu 18.04 LTS
if [[ $(lsb_release -rs) != "18.04" || $(lsb_release -is) != "Ubuntu" ]]; then
    echo "The system is not Ubuntu 18.04 LTS."
    exit 1
fi

# Verify that LoginGraceTime is between 1 and 60
echo "Verifying LoginGraceTime in SSH configuration..."
login_grace_time=$(sshd -T | grep -i logingracetime | awk '{print $2}')

if [[ "$login_grace_time" -ge 1 && "$login_grace_time" -le 60 ]]; then
    echo "LoginGraceTime is set to $login_grace_time, which is within the acceptable range."
else
    echo "LoginGraceTime is not within the acceptable range. Updating the /etc/ssh/sshd_config file..."
    
    # Update the /etc/ssh/sshd_config file to set LoginGraceTime to 60
    if grep -q "^LoginGraceTime" /etc/ssh/sshd_config; then
        sudo sed -i 's/^LoginGraceTime.*/LoginGraceTime 60/' /etc/ssh/sshd_config
    else
        echo "LoginGraceTime 60" | sudo tee -a /etc/ssh/sshd_config
    fi
    
    # Restart the SSH service to apply changes
    sudo systemctl restart sshd
    
    echo "LoginGraceTime has been set to 60 and SSH service has been restarted."
fi
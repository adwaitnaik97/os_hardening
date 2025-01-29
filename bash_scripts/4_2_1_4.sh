#!/bin/bash

# Check if the system is Ubuntu 18.04 LTS
if [[ $(lsb_release -rs) != "18.04" || $(lsb_release -is) != "Ubuntu" ]]; then
    echo "The system is not Ubuntu 18.04 LTS."
    exit 1
fi

# Verify that $FileCreateMode is 0640 or more restrictive
echo "Verifying that \$FileCreateMode is 0640 or more restrictive..."
file_create_mode=$(grep ^\$FileCreateMode /etc/rsyslog.conf /etc/rsyslog.d/*.conf)

if echo "$file_create_mode" | grep -q "\$FileCreateMode 0640"; then
    echo "\$FileCreateMode is set to 0640 or more restrictive."
else
    echo "\$FileCreateMode is not set to 0640 or more restrictive. Updating the configuration..."
    
    # Update /etc/rsyslog.conf
    if grep -q ^\$FileCreateMode /etc/rsyslog.conf; then
        sudo sed -i 's/^\$FileCreateMode.*/\$FileCreateMode 0640/' /etc/rsyslog.conf
    else
        echo "\$FileCreateMode 0640" | sudo tee -a /etc/rsyslog.conf
    fi
    
    # Update /etc/rsyslog.d/*.conf
    for file in /etc/rsyslog.d/*.conf; do
        if grep -q ^\$FileCreateMode "$file"; then
            sudo sed -i 's/^\$FileCreateMode.*/\$FileCreateMode 0640/' "$file"
        else
            echo "\$FileCreateMode 0640" | sudo tee -a "$file"
        fi
    done
    
    # Restart rsyslog service to apply changes
    sudo systemctl restart rsyslog
    
    echo "\$FileCreateMode has been set to 0640 and rsyslog service has been restarted."
fi

# Verify the updated configuration
echo "Verifying the updated configuration..."
grep ^\$FileCreateMode /etc/rsyslog.conf /etc/rsyslog.d/*.conf
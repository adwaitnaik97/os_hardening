#! /bin/bash

# Check if the system is Ubuntu 18.04 LTS
if [[ $(lsb_release -rs) == "18.04" && $(lsb_release -is) == "Ubuntu" ]]; then
    echo "The system is Ubuntu 18.04 LTS."
else
    echo "The system is not Ubuntu 18.04 LTS."
    exit 1
fi

# Verify that cron is enabled
echo "Verifying if cron is enabled..."
cron_status=$(systemctl is-enabled cron)

if [[ "$cron_status" == "enabled" ]]; then
    echo "cron is enabled."
else
    echo "cron is not enabled. Enabling cron..."
    sudo systemctl --now enable cron
    sudo systemctl start cron
    echo "cron has been enabled and started."
fi
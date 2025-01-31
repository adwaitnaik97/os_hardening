#! /bin/bash

# Check if the system is Ubuntu 18.04 LTS
if [[ $(lsb_release -rs) == "18.04" && $(lsb_release -is) == "Ubuntu" ]]; then
    echo "The system is Ubuntu 18.04 LTS."
else
    echo "The system is not Ubuntu 18.04 LTS."
    exit 1
fi

# Check if a cron job is scheduled to run the AIDE check
if sudo crontab -u root -l | grep aide && grep -r aide /etc/cron.* /etc/crontab; then
    echo "A cron job is scheduled to run the AIDE check."
else
    echo "A cron job is not scheduled to run the AIDE check."
    echo "Scheduling a cron job to run the AIDE check."
    # Define the cron job line
    cron_job="0 5 * * * /usr/bin/aide.wrapper --config /etc/aide/aide.conf --check"

    # Check if the cron job already exists
    (sudo crontab -u root -l | grep -F "$cron_job") && echo "Cron job already exists." && exit 0

    # Add the cron job to the root user's crontab
    (sudo crontab -u root -l; echo "$cron_job") | crontab -u root -

    echo "Cron job added to root's crontab."
fi
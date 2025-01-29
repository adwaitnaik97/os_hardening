#!/bin/bash

# Check if the system is Ubuntu 18.04 LTS
if [[ $(lsb_release -rs) == "18.04" && $(lsb_release -is) == "Ubuntu" ]]; then
    echo "The system is Ubuntu 18.04 LTS."
else
    echo "The system is not Ubuntu 18.04 LTS."
    exit 1
fi

# Check if the umask parameter is 027
if grep -q "umask 027" /etc/bash.bashrc && grep -q "umask 027" /etc/profile && grep -q "umask 027" /etc/profile.d/*.sh; then
    echo "The umask parameter is set to 027."
else
    echo "The umask parameter is not set to 027."
    echo "Setting the umask parameter to 027..."

    # Function to set umask to 027 in a file
    set_umask() {
        local file=$1
        if grep -q "umask" "$file"; then
            sudo sed -i 's/^umask.*/umask 027/' "$file"
        else
            echo "umask 027" | sudo tee -a "$file"
        fi
    }

    # Set umask to 027 in /etc/bash.bashrc
    set_umask /etc/bash.bashrc

    # Set umask to 027 in /etc/profile
    set_umask /etc/profile

    # Set umask to 027 in all /etc/profile.d/*.sh files
    for file in /etc/profile.d/*.sh; do
        set_umask "$file"
    done

    echo "The umask parameter has been set to 027 in /etc/bash.bashrc, /etc/profile, and /etc/profile.d/*.sh files."
fi
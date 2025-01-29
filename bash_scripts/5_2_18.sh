#!/bin/bash

# Check if the system is Ubuntu 18.04 LTS
if [[ $(lsb_release -rs) != "18.04" || $(lsb_release -is) != "Ubuntu" ]]; then
    echo "The system is not Ubuntu 18.04 LTS."
    exit 1
fi

# Verify that at least one of the SSH access control parameters is set
echo "Verifying SSH access control parameters..."
allowusers=$(sshd -T | grep allowusers)
allowgroups=$(sshd -T | grep allowgroups)
denyusers=$(sshd -T | grep denyusers)
denygroups=$(sshd -T | grep denygroups)

if [[ -n "$allowusers" || -n "$allowgroups" || -n "$denyusers" || -n "$denygroups" ]]; then
    echo "At least one SSH access control parameter is set:"
    [[ -n "$allowusers" ]] && echo "$allowusers"
    [[ -n "$allowgroups" ]] && echo "$allowgroups"
    [[ -n "$denyusers" ]] && echo "$denyusers"
    [[ -n "$denygroups" ]] && echo "$denygroups"
else
    echo "No SSH access control parameters are set. Updating the /etc/ssh/sshd_config file..."
    
    # Example remediation: Set AllowUsers to a specific user (replace <userlist> with actual user list)
    echo "AllowUsers <userlist>" | sudo tee -a /etc/ssh/sshd_config
    
    # Restart the SSH service to apply changes
    sudo systemctl restart sshd
    
    echo "SSH access control parameter AllowUsers has been set and SSH service has been restarted."
fi
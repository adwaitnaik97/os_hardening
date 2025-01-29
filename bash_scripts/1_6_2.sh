#!/bin/bash

# Check if the system is Ubuntu 18.04 LTS
if [[ $(lsb_release -rs) != "18.04" || $(lsb_release -is) != "Ubuntu" ]]; then
    echo "The system is not Ubuntu 18.04 LTS."
    exit 1
fi

# Verify kernel.randomize_va_space is set to 2
echo "Verifying kernel.randomize_va_space..."
sysctl_output=$(sysctl kernel.randomize_va_space)
grep_output=$(grep "kernel\.randomize_va_space" /etc/sysctl.conf /etc/sysctl.d/*)

if [[ "$sysctl_output" == "kernel.randomize_va_space = 2" && "$grep_output" == *"kernel.randomize_va_space = 2"* ]]; then
    echo "kernel.randomize_va_space is set to 2."
else
    echo "kernel.randomize_va_space is not set to 2. Updating the configuration..."
    
    # Update /etc/sysctl.conf or create a new file in /etc/sysctl.d/
    if grep -q "kernel.randomize_va_space" /etc/sysctl.conf; then
        sudo sed -i 's/^kernel.randomize_va_space.*/kernel.randomize_va_space = 2/' /etc/sysctl.conf
    else
        echo "kernel.randomize_va_space = 2" | sudo tee -a /etc/sysctl.conf
    fi
    
    # Apply the kernel parameter
    sudo sysctl -w kernel.randomize_va_space=2
    
    echo "kernel.randomize_va_space has been set to 2."
fi

# Verify the updated configuration
echo "Verifying the updated configuration..."
sysctl kernel.randomize_va_space
grep "kernel\.randomize_va_space" /etc/sysctl.conf /etc/sysctl.d/*
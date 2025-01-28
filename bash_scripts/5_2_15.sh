#!/bin/bash

# Check if the system is Ubuntu 18.04 LTS
if [[ $(lsb_release -rs) == "18.04" && $(lsb_release -is) == "Ubuntu" ]]; then
    echo "The system is Ubuntu 18.04 LTS."
else
    echo "The system is not Ubuntu 18.04 LTS."
    exit 1
fi

# Define the weak Key Exchange algorithms
weak_kex_algorithms=(
    "diffie-hellman-group1-sha1"
    "diffie-hellman-group14-sha1"
    "diffie-hellman-group-exchange-sha1"
)

# Define the approved Key Exchange algorithms
approved_kex_algorithms="curve25519-sha256,curve25519-sha256@libssh.org,diffie-hellman-group14-sha256,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512,ecdh-sha2-nistp521,ecdh-sha2-nistp384,ecdh-sha2-nistp256,diffie-hellman-group-exchange-sha256"

# Check the current Key Exchange algorithms
current_kex_algorithms=$(sshd -T | grep kexalgorithms | awk '{print $2}')

# Check if any weak Key Exchange algorithms are present
for weak_kex in "${weak_kex_algorithms[@]}"; do
    if echo "$current_kex_algorithms" | grep -q "$weak_kex"; then
        echo "Weak Key Exchange algorithm $weak_kex found. Updating the sshd_config file..."
        
        # Backup the original sshd_config file
        sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

        # Add or modify the KexAlgorithms line in the sshd_config file
        if grep -q "^KexAlgorithms" /etc/ssh/sshd_config; then
            sudo sed -i "s/^KexAlgorithms.*/KexAlgorithms $approved_kex_algorithms/" /etc/ssh/sshd_config
        else
            echo "KexAlgorithms $approved_kex_algorithms" | sudo tee -a /etc/ssh/sshd_config
        fi

        # Restart the SSH service to apply changes
        echo "Restarting the SSH service..."
        sudo systemctl restart sshd

        echo "The KexAlgorithms line has been updated in /etc/ssh/sshd_config."
        exit 0
    fi
done

echo "No weak Key Exchange algorithms found."
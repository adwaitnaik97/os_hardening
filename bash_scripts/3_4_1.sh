#!/bin/bash

# Check if the system is Ubuntu 18.04 LTS
if [[ $(lsb_release -rs) != "18.04" || $(lsb_release -is) != "Ubuntu" ]]; then
    echo "The system is not Ubuntu 18.04 LTS."
    exit 1
fi

# Verify the output of modprobe for dccp
echo "Verifying the output of modprobe for dccp..."
modprobe_output=$(modprobe -n -v dccp)
expected_output="install /bin/true"

if [[ "$modprobe_output" == "$expected_output" ]]; then
    echo "modprobe output is correct: $modprobe_output"
else
    echo "modprobe output is not correct. Updating the configuration..."
    echo "install dccp /bin/true" | sudo tee /etc/modprobe.d/dccp.conf
    echo "Configuration has been updated."
fi

# Verify the output of lsmod for dccp
echo "Verifying the output of lsmod for dccp..."
lsmod_output=$(lsmod | grep dccp)

if [[ -z "$lsmod_output" ]]; then
    echo "No output from lsmod for dccp, as expected."
else
    echo "Unexpected output from lsmod for dccp: $lsmod_output"
    echo "Disabling the dccp module..."
    echo "install dccp /bin/true" | sudo tee /etc/modprobe.d/dccp.conf
    sudo rmmod dccp
    echo "dccp module has been disabled."
fi

# Verify the updated configuration
echo "Verifying the updated configuration..."
modprobe -n -v dccp
lsmod | grep dccp
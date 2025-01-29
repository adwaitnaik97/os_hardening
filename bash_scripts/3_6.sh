#! /bin/bash

# Check if the system is Ubuntu 18.04 LTS
if [[ $(lsb_release -rs) == "18.04" && $(lsb_release -is) == "Ubuntu" ]]; then
    echo "The system is Ubuntu 18.04 LTS."
else
    echo "The system is not Ubuntu 18.04 LTS."
    exit 1
fi

# Check wireless interfaces status
echo "Checking wireless interfaces status..."
nmcli_output=$(nmcli radio all)

echo "Output of 'nmcli radio all':"
echo "$nmcli_output"

# Verify that no wireless interfaces are active
if echo "$nmcli_output" | grep -q "enabled.*disabled.*enabled.*disabled"; then
    echo "No wireless interfaces are active on the system."
else
    echo "Some wireless interfaces are active on the system."
    echo "Disabling all wireless interfaces..."
    nmcli radio all off
    echo "All wireless interfaces have been disabled."
    echo "The WiFi has been disabled."
fi
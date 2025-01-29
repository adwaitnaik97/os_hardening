#!/bin/bash

# Check if the system is Ubuntu 18.04 LTS
if [[ $(lsb_release -rs) == "18.04" && $(lsb_release -is) == "Ubuntu" ]]; then
    echo "The system is Ubuntu 18.04 LTS."
else
    echo "The system is not Ubuntu 18.04 LTS."
    exit 1
fi

# Verify the output of the grep command
echo "Verifying the output of the grep command..."
grep_output=$(grep "^\s*[^#]" /etc/audit/audit.rules | tail -1)

if [[ "$grep_output" == "-e 2" ]]; then
    echo "The output matches: -e 2"
else
    echo "The output does not match. Expected: -e 2, Actual: $grep_output"
    echo "Updating /etc/audit/rules.d/99-finalize.rules to include -e 2..."
    
    # Create or edit the /etc/audit/rules.d/99-finalize.rules file
    sudo bash -c 'echo "-e 2" > /etc/audit/rules.d/99-finalize.rules'
    
    echo "/etc/audit/rules.d/99-finalize.rules has been updated to include -e 2."
fi

# Verify the content of /etc/audit/rules.d/99-finalize.rules
echo "Verifying the content of /etc/audit/rules.d/99-finalize.rules..."
if grep -q "^\s*-e 2" /etc/audit/rules.d/99-finalize.rules; then
    echo "The file /etc/audit/rules.d/99-finalize.rules contains the line: -e 2"
else
    echo "The file /etc/audit/rules.d/99-finalize.rules does not contain the line: -e 2"
    exit 1
fi
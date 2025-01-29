#!/bin/bash

# Check if the system is Ubuntu 18.04 LTS
if [[ $(lsb_release -rs) == "18.04" && $(lsb_release -is) == "Ubuntu" ]]; then
    echo "The system is Ubuntu 18.04 LTS."
else
    echo "The system is not Ubuntu 18.04 LTS."
    exit 1
fi

# Verify no results are returned for the first command
echo "Running the first verification command..."
first_command_output=$(awk -F: '($1!="root" && $1!="sync" && $1!="shutdown" && $1!="halt" && $1!~/^\+/ && $3<'"$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)"' && $7!="'"$(which nologin)"'" && $7!="/bin/false") {print}' /etc/passwd)

if [[ -z "$first_command_output" ]]; then
    echo "First verification command returned no results."
else
    echo "First verification command returned results:"
    echo "$first_command_output"
    echo "Setting the shell for the accounts returned by the audit to nologin..."
    echo "$first_command_output" | awk -F: '{print $1}' | while read -r user; do
        sudo usermod -s "$(which nologin)" "$user"
    done
    echo "Shell has been set to nologin for the accounts returned by the audit."
fi

# Verify no results are returned for the second command
echo "Running the second verification command..."
second_command_output=$(awk -F: '($1!="root" && $1!~/^\+/ && $3<'"$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)"') {print $1}' /etc/passwd | xargs -I '{}' passwd -S '{}' | awk '($2!="L" && $2!="LK") {print $1}')

if [[ -z "$second_command_output" ]]; then
    echo "Second verification command returned no results."
else
    echo "Second verification command returned results:"
    echo "$second_command_output"
    echo "Locking the non-root accounts returned by the audit..."
    echo "$second_command_output" | while read -r user; do
        sudo usermod -L "$user"
    done
    echo "Non-root accounts returned by the audit have been locked."
fi

# Set all system accounts to a non-login shell
echo "Setting all system accounts to a non-login shell..."
awk -F: '($1!="root" && $1!="sync" && $1!="shutdown" && $1!="halt" && $1!~/^\+/ && $3<'"$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)"' && $7!="'"$(which nologin)"'" && $7!="/bin/false") {print $1}' /etc/passwd | while read -r user; do
    sudo usermod -s "$(which nologin)" "$user"
done
echo "All system accounts have been set to a non-login shell."

# Automatically lock non-root system accounts
echo "Automatically locking non-root system accounts..."
awk -F: '($1!="root" && $1!~/^\+/ && $3<'"$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)"') {print $1}' /etc/passwd | xargs -I '{}' passwd -S '{}' | awk '($2!="L" && $2!="LK") {print $1}' | while read -r user; do
    sudo usermod -L "$user"
done
echo "Non-root system accounts have been automatically locked."
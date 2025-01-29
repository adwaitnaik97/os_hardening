#!/bin/bash

# Check if the system is Ubuntu 18.04 LTS
if [[ $(lsb_release -rs) == "18.04" && $(lsb_release -is) == "Ubuntu" ]]; then
    echo "The system is Ubuntu 18.04 LTS."
else
    echo "The system is not Ubuntu 18.04 LTS."
    exit 1
fi

# Check for the users' dot files aren't group or world writable files 
grep -E -v '^(halt|sync|shutdown)' /etc/passwd | awk -F: '($7 != "'"$(which nologin)"'" && $7 != "/bin/false") { print $1 " " $6 }' | while read -r user dir; do
    if [ ! -d "$dir" ]; then
        echo "The home directory \"$dir\" of user \"$user\" does not exist."
    else
        for file in "$dir"/.[A-Za-z0-9]*; do
            if [ ! -h "$file" ] && [ -f "$file" ]; then
                fileperm="$(ls -ld "$file" | cut -f1 -d" ")"
                if [ "$(echo "$fileperm" | cut -c6)" != "-" ]; then
                    echo "Group Write permission set on file \"$file\""
                fi
                if [ "$(echo "$fileperm" | cut -c9)" != "-" ]; then
                    echo "Other Write permission set on file \"$file\""
                fi
            fi
        done
    fi
done
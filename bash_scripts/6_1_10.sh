# Check if the system is Ubuntu 18.04 LTS
if [[ $(lsb_release -rs) != "18.04" || $(lsb_release -is) != "Ubuntu" ]]; then
    echo "The system is not Ubuntu 18.04 LTS."
    exit 1
fi

# Check for world-writable files
echo "Checking for world-writable files..."
world_writable_files=$(find / -xdev -type f -perm -0002)

if [[ -z "$world_writable_files" ]]; then
    echo "No world-writable files exist."
else
    echo "World-writable files exist:"
    echo "$world_writable_files"
    exit 1
fi
#!/bin/bash

# Map of source directories to mount locations
declare -A MOUNT_MAP=(
    ["/home/aneem/jellyfin-movies"]="jellyfin-movies"
    ["/home/aneem/.int-certs"]="int"
    ["/home/aneem/Downloads"]="downloads"
    ["/run/media/aneem/OMEGA/BACKUPS/NEW-SSD/EndeavourOS2024/HOME/.int-certs/images/"]="int-img"
    ["/run/media/aneem/OMEGA/BACKUPS/NEW-SSD/EndeavourOS2024/HOME/.int-certs/videos/"]="int-vid"
)

# Root path to be added to each destination path
MOUNT_ROOT_PATH="/media/"

# jellyfin-start function
jellyfin-start() {
    echo "Starting Jellyfin service..."
    # Start the jellyfin service
    sudo systemctl start jellyfin

    # Allow TCP traffic to port 8096 for the current session
    echo "Configuring firewall to allow TCP traffic on port 8096..."
    sudo firewall-cmd --add-port=8096/tcp

    # Mount directories based on the map
    for SOURCE in "${!MOUNT_MAP[@]}"; do
        DESTINATION="${MOUNT_ROOT_PATH}${MOUNT_MAP[$SOURCE]}"
        if [[ -d "$SOURCE" && -d "$DESTINATION" ]]; then
            echo "Mounting $SOURCE to $DESTINATION..."
            sudo mount --bind "$SOURCE" "$DESTINATION"
        else
            echo "Skipping $SOURCE -> $DESTINATION. Ensure both directories exist."
        fi
    done
}

# jellyfin-stop function
jellyfin-stop() {
    echo "Stopping Jellyfin service..."
    # Stop the jellyfin service
    sudo systemctl stop jellyfin

    # Remove the TCP port allowance from the firewall
    echo "Removing firewall rule for TCP traffic on port 8096..."
    sudo firewall-cmd --remove-port=8096/tcp

    # Unmount directories based on the map
    for SOURCE in "${!MOUNT_MAP[@]}"; do
        DESTINATION="${MOUNT_ROOT_PATH}${MOUNT_MAP[$SOURCE]}"
        if mountpoint -q "$DESTINATION"; then
            echo "Unmounting $DESTINATION..."
            sudo umount "$DESTINATION"
        else
            echo "$DESTINATION is not mounted. Skipping..."
        fi
    done
}

# Help message
if [[ "$1" == "start" ]]; then
    jellyfin-start
elif [[ "$1" == "stop" ]]; then
    jellyfin-stop
else
    echo "Usage: $0 {start|stop}"
fi

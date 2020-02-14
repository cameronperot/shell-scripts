#!/usr/bin/env bash
set -eu -o pipefail

mount_device=$1
mount_dir=/mnt/backup_usb
rsync_source=/home/"$USER"/rsync/
rsync_dest="$mount_dir"/rsync/

# Check that the mount directory exists
if [ ! -d "$mount_dir" ]; then
    sudo mkdir "$mount_dir"
    sudo chown -R "$USER":"$USER" "$mount_dir"
fi

# Mount the device
sudo mount -t ext4 "$mount_device" "$mount_dir"

# Check that the rsync source and destination directories exist
if [ ! -d "$rsync_source" ]; then
    echo "Sync source directory does not exist"
    exit 1
elif [ ! -d "$rsync_dest" ]; then
    echo "Sync destination directory does not exist"
    exit 1
fi

# Give ownership to the current user
sudo chown -R "$USER":"$USER" "$rsync_dest"

# Sync the files
rsync -av --progress --update "$rsync_source" "$rsync_dest"

# Echo upon success
echo "Files have been successfully synced!"

# Unmount the device
sudo umount "$mount_dir"

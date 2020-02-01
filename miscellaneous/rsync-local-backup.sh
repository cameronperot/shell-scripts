#!/bin/bash
set -e

echo "Backing up Documents..."
rsync -av --update --delete-before /media/veracrypt1/Documents/ /media/veracrypt2/Documents/

echo "Backing up Videos..."
rsync -av --update --delete-before --exclude 'Educational' --exclude 'Unwatched' /media/veracrypt1/Videos/ /media/veracrypt2/Videos/

echo "Backing up Pictures..."
rsync -av --update --delete-before /media/veracrypt1/Pictures/ /media/veracrypt2/Pictures/

echo "Backing up rsync folder..."
rsync -av --update --delete-before /media/veracrypt1/rsync/ /media/veracrypt2/rsync/

echo "Backup complete!"

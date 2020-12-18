#!/bin/bash
USER=nimbix

source /etc/overlay_settle.sh

mkdir -p /home/$USER/Desktop
cp -p /etc/README.txt /home/$USER/Desktop
/usr/local/bin/nimbix_desktop
mkdir -p /home/$USER/Desktop
cp -p /etc/README.txt /home/$USER/Desktop

source /etc/overlay_settle.sh

exit 0

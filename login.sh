#!/bin/bash
USER=nimbix

mkdir -p /home/$USER/Desktop
cp -p /etc/README.txt /home/$USER/Desktop
/usr/local/bin/nimbix_desktop
mkdir -p /home/$USER/Desktop
cp -p /etc/README.txt /home/$USER/Desktop

exit 0

#!/bin/bash

# NTP: ntpd is the old one crony is recommended by Red Hat
sudo yum -y install crony

# Check status
sudo systemctl status cronyd

# Edit crony config
sudo vim /etc/crony.conf

# Add firewall rule if configured as server
firewall-cmd --permanent --zone=public --add-service ntp

# Reload
firewall-cmd --reload

# Show everything
firewall-cmd --list-all

# Enable ntp on system
sudo timedatectl set-ntp true

# Show source
sudo cronyc sources -v

# Set timezone
timedatectl list-timezones | grep Zurich
# Set the zone
timedatectl set-zimezone Europe....
# Set Time manually
timedatectl set-time '2019-11-11 23:11:11'

# If you want to change to automatic, enable ntp boolean and restart timedated
sudo systemctl restart systemd-timedated

## Show used time servers
chronyc sources
chronyc sources -v

cronyc sourcestats

# Show time server sync
chronyc tracking

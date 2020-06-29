#!/bin/bash

# Check status
systemctl status firewalld

# Start and enable
systemctl start firewalld
systemctl enable firewalld

## list all services
firewall-cmd --list-services

# Show everything
firewall-cmd --list-all

## list open ports
firewall-cmd --list-ports

# Add open ports
firewall-cmd --zone=public --add-port={389/tcp,636/tcp,9830/tcp} --permanent 

# Remove open ports
firewall-cmd --zone=public --remove-port=5454/tcp --permanent

# Reload rules
firewall-cmd --reload
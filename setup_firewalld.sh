#!/bin/bash

# Check status
systemctl status firewalld

# Start and enable
systemctl start firewalld
systemctl enable firewalld

## list all services
firewall-cmd --list-services

## list open ports
firewall-cmd --list-ports

# Add rules test
firewall-cmd --permanent --add-port={389/tcp,636/tcp,9830/tcp}

# Reload rules
firewall-cmd --reload
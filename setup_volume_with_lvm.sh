#!/bin/bash

# Get smartmontools
sudo yum install smartmontools

# Show all informations about drive like running hours
sudo smartctl -a /dev/sda1

sudo smartctl -t short /dev/sda1

# Partitions information from kernel
cat /proc/partitions

# Another tool for list partition information
lsblk

# list partitions on device
fdisk -l /dev/vda

# Create partition on disk
gdisk /dev/vdb
>n
>enter
>+500M
>p
>w
#Reload partition table
sudo partprobe

# 1
# Create physical volume
sudo pvcreate /dev/vdb1

# Verify pv creation
pvs

# More infromation about pv
pvdisplay

# 2
# Create RHCSA group on pv
sudo vgcreate RHCSA /dev/vdb1 # /dev/vdb2 would be possible

# Verify volume group creation
vgs

# More information vgdisplay
vgdisplay

# 3
# Create logical volume with name lvdate on RHCSA group
sudo lvcreate --name lvdata --size 495M RHCSA

#Größenangabe in z.B. Gigabyte:
lvcreate -n data -L1G vg00

# Angabe in Prozent des verfügbaren Speichers in der VG:
lvcreate -n data -l100%VG vg00

# Angabe in Prozent des freien Speichers in der VG:
lvcreate -n data -l100%FREE vg00

# Verify logical volume creation
lvs

# More information
lvdisplay

# 4 Format logical volume
sudo mkfs -t xfs /dev/RHCSA/lvdata

# Verify
blkid

# 5 Create mount point
sudo mkdir /media/lvdata
sudo mount /dev/RHCSA/lvdata /media/lvdata

# Verify
df -T

# Show mount options
mount

# 5 
# Add auto mount
sudo vim /etc/fstab
/dev/RHCSA/lvdata	/media/lvdata	xfs	defaults	0 0

# 6
# Unmount and Mount everything
unmount /media/lvdata
mount -a

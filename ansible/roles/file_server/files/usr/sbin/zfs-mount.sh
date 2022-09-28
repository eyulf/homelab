#!/bin/bash

# Open lvmcrypt devices
cryptsetup luksOpen /dev/disk/by-uuid/feba882d-63b6-42cb-840d-21c9ab32f4da sda_crypt
cryptsetup luksOpen /dev/disk/by-uuid/de14b701-050d-4a1c-8dd4-6738202dca8e sdb_crypt
cryptsetup luksOpen /dev/disk/by-uuid/1e90cbf4-2558-47a1-b7f6-c2fa35903b68 sdc_crypt
cryptsetup luksOpen /dev/disk/by-uuid/ce41dca6-8d73-4e21-8a31-3168c1f3687f sdd_crypt
cryptsetup luksOpen /dev/disk/by-uuid/fe7c2c88-a063-456f-898c-851684dcd6b1 sde_crypt
cryptsetup luksOpen /dev/disk/by-uuid/402f8088-44a4-4b4c-b318-48c1c9e856c4 sdf_crypt
cryptsetup luksOpen /dev/disk/by-uuid/ae706f32-62d4-4a26-8567-86696746f3bd sdg_crypt

# Mount zfs filesystem
zpool import storage

# Show status
zpool status

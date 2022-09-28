#!/bin/bash

# Unmount zfs filesystems
zfs unmount -a

# Export zfs pools
zpool export -a

# Close lvmcrypt devices
cryptsetup luksClose sda_crypt
cryptsetup luksClose sdb_crypt
cryptsetup luksClose sdc_crypt
cryptsetup luksClose sdd_crypt
cryptsetup luksClose sde_crypt
cryptsetup luksClose sdf_crypt
cryptsetup luksClose sdg_crypt

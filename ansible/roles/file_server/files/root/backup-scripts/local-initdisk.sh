#!/bin/bash

################################################################################
# SETTINGS

RUNPATH='/root'
WIDTH='34'

BACKUP_CRYPT_NAME='backup_crypt'
BACKUP_CRYPT_DEVICE="/dev/mapper/${BACKUP_CRYPT_NAME}"
BACKUP_PATH='/backup'

################################################################################
# SANITY CHECKS

#######################################
# Missing Files

printf "%-${WIDTH}s" "- Checking for files needed: "

if ! [ -d /backup ] || ! [ -d "${RUNPATH}" ] || ! [ -f "${RUNPATH}/backup.pass" ]; then
  printf "%s\n" "[FAILED]"
  exit
fi

printf "%s\n" "[OK]"

#######################################
# Disk Present

printf "%-${WIDTH}s" "- Checking for Backup Disk: "

DISK=$(hwinfo --disk --short | grep -v -E 'disk:|Seagate IronWolf|WDC WD30EFRX' | grep '/dev/' | awk '{print $1}')

if [ "$DISK" == "" ]; then
  printf "%s\n" "[FAILED]"
  printf "\n%s\n" "Backup Disk not found!"
  hwinfo --disk --short
  exit
elif (( $(grep -c . <<<"$DISK") > 1 )); then
  printf "%s\n" "[FAILED]"
  printf "\n%s\n" "More then 1 Backup Disk present!"
  hwinfo --disk --short
  exit
else
  printf "%s\n" "[OK]"
fi

#######################################
# Confirmation

echo
echo "Disk Found:"
hwinfo --disk --short | grep "$DISK"
fdisk -l | grep "$DISK"

echo
read -p "Continue? (y) " -n 1 -r
echo

if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit
fi

#######################################
# Filesystem Mounted

if mount | grep "$BACKUP_PATH" >/dev/null; then
  echo "- Unmounting Filesystem"
  umount "$BACKUP_PATH"
fi

#######################################
# Encryption present

if cryptsetup isLuks "$DISK" >/dev/null ; then
  echo  "- Removing Encryption"
  cryptsetup luksClose "$BACKUP_CRYPT_NAME"
  cryptsetup erase "$DISK"
fi

################################################################################
# DO THE THING

echo ""
echo "- Encrypting Disk"
cryptsetup --batch-mode --key-file "${RUNPATH}/backup.pass" -v --type luks2 luksFormat "$DISK"

echo ""
echo "- Opening Encrypted Disk"
cryptsetup --key-file "${RUNPATH}/backup.pass" luksOpen "$DISK" "$BACKUP_CRYPT_NAME"
cryptsetup -v status "$BACKUP_CRYPT_NAME"

echo ""
echo "- Zeroing the Disk"
echo "Note: This can take hours!"
pv < /dev/zero > "$BACKUP_CRYPT_DEVICE"

echo ""
echo "- Creating Filesystem"
mkfs.ext4 "$BACKUP_CRYPT_DEVICE"

echo ""
echo  "- Mounting Filesystem"
mount "$BACKUP_CRYPT_DEVICE" "$BACKUP_PATH"
df -h "$BACKUP_PATH"

echo ""
echo  "- Unmounting Filesystem"
umount "$BACKUP_PATH"
df -h "$BACKUP_PATH"

echo ""
echo "- Closing Encrypted Disk"
cryptsetup luksClose "$BACKUP_CRYPT_NAME"

echo ""
echo "DISK IS READY FOR BACKUPS"

#!/bin/bash

################################################################################
# SETTINGS

RUNPATH='/root'
SCRIPTPATH="$RUNPATH/backup-scripts"
WIDTH='34'

BACKUP_CRYPT_NAME='backup_crypt'
BACKUP_CRYPT_DEVICE="/dev/mapper/${BACKUP_CRYPT_NAME}"
BACKUP_PATH='/backup'

################################################################################
# SANITY CHECKS

#######################################
# Backup Running

printf "%-${WIDTH}s" "- Checking for existing backups: "
logger -it "BACKUP-SCRIPTS" "Checking for existing backups"

if screen -ls >/dev/null; then
  printf "%s\n" "[Failed]"
  printf "\n%s\n" "Backup Already Running!"
  printf "%s\n" "$(cat "${RUNPATH}/backup-progress")"
  logger -it "BACKUP-SCRIPTS" "Local backup failed!"
  logger -it "BACKUP-SCRIPTS" "Backup Already Running!"
  exit
else
  printf "%s\n" "[OK]"
fi

#######################################
# Missing Files

printf "%-${WIDTH}s" "- Checking for files needed: "
logger -it "BACKUP-SCRIPTS" "Checking for files needed"

if ! [ -d /backup ] || ! [ -d "${RUNPATH}" ] || ! [ -f "${RUNPATH}/backup.pass" ]; then
  printf "%s\n" "[FAILED]"
  logger -it "BACKUP-SCRIPTS" "Local backup failed!"
  logger -it "BACKUP-SCRIPTS" "Files not Found!"
  exit
fi

printf "%s\n" "[OK]"

#######################################
# Disk Present

printf "%-${WIDTH}s" "- Checking for Backup Disk: "
logger -it "BACKUP-SCRIPTS" "Checking for Backup Disk"

DISK=$(/usr/sbin/hwinfo --disk --short | grep -v -E 'disk:|Seagate IronWolf|WDC WD30EFRX' | grep '/dev/' | awk '{print $1}')

if [ "$DISK" == "" ]; then
  printf "%s\n" "[FAILED]"
  printf "\n%s\n" "Backup Disk not found!"
  /usr/sbin/hwinfo --disk --short
  logger -it "BACKUP-SCRIPTS" "Local backup failed!"
  logger -it "BACKUP-SCRIPTS" "Backup Disk not found"
  exit
elif (( $(grep -c . <<<"$DISK") > 1 )); then
  printf "%s\n" "[FAILED]"
  printf "\n%s\n" "More then 1 Backup Disk present!"
  /usr/sbin/hwinfo --disk --short
  logger -it "BACKUP-SCRIPTS" "Local backup failed!"
  logger -it "BACKUP-SCRIPTS" "More then 1 Backup Disk present"
  exit
else
  printf "%s\n" "[OK] (${DISK})"
  logger -it "BACKUP-SCRIPTS" " - Backup Disk: ${DISK}"
fi

#######################################
# Encryption present

printf "%-${WIDTH}s" "- Checking Encryption: "
logger -it "BACKUP-SCRIPTS" "Checking Encryption"

if ! /usr/sbin/cryptsetup isLuks "$DISK" >/dev/null ; then
  printf "%s\n" "[FAILED]"
  printf "\n%s\n" "Disk is not Encrypted!!!"
  logger -it "BACKUP-SCRIPTS" "Local backup failed!"
  logger -it "BACKUP-SCRIPTS" "Disk (${DISK}) is not Encrypted"
  exit
else
  /usr/sbin/cryptsetup --key-file "${RUNPATH}/backup.pass" luksOpen "$DISK" "$BACKUP_CRYPT_NAME"
  printf "%s\n" "[OK]"
fi

#######################################
# Filesystem Mounted

printf "%-${WIDTH}s" "- Checking Filesystem: "
logger -it "BACKUP-SCRIPTS" "Checking Filesystem"

if ! mount | grep "$BACKUP_CRYPT_DEVICE" >/dev/null; then
  mount "$BACKUP_CRYPT_DEVICE" "$BACKUP_PATH"
fi

if ! mount | grep "$BACKUP_CRYPT_DEVICE" >/dev/null; then
  printf "%s\n" "[FAILED]"
  printf "\n%s\n" "Filesystem Not Present!!!"
  logger -it "BACKUP-SCRIPTS" "Local backup failed!"
  logger -it "BACKUP-SCRIPTS" "Filesystem Not Present"
  exit
else
  printf "%s\n" "[OK]"
fi

#######################################
# Getting Disk Details

printf "%-${WIDTH}s" "- Getting Disk Details: "
logger -it "BACKUP-SCRIPTS" "Getting Disk Details"

# Get Size of disk in MiB
DISK_SIZE=$(df -m "$BACKUP_CRYPT_DEVICE" | awk '{ if ( NR > 1  ) print $2}')

# Allow for reserved blocks/etc to prevent adversely affecting performance
DISK_SIZE=$(echo "scale=0; ${DISK_SIZE} * 0.92" | bc)
DISK_SIZE=$(printf "%.0f" "$DISK_SIZE")

printf "%s\n" "[OK]"

#######################################
# Check Backup Size

printf "%-${WIDTH}s\n" "- Calculating Backup Size:"
logger -it "BACKUP-SCRIPTS" "Calculating Backup Size"

# Get Size of T5 backups in MiB
BACKUP_SIZE=0

while IFS= read -r DIR; do
  T5_BACKUP_SIZE=$(( BACKUP_SIZE + $(du -ms "$DIR" | awk '{print $1}') ))
done < "${RUNPATH}/backup-tier5.txt"

# Get Size of T2 backups in MiB
BACKUP_SIZE=0

while IFS= read -r DIR; do
  T2_BACKUP_SIZE=$(( BACKUP_SIZE + $(du -ms "$DIR" | awk '{print $1}') ))
done < "${RUNPATH}/backup-tier2.txt"

# Determine what backup tier to run based on disk size

TIER="t5"
BACKUP_SOURCE_FILE="${RUNPATH}/backup-tier5.txt"

if [ "$T5_BACKUP_SIZE" -gt "$DISK_SIZE" ]; then
  printf "%s\n" "  Tier 5 Backup Size (${T5_BACKUP_SIZE}) Exceeds Disk Size (${DISK_SIZE})"
  logger -it "BACKUP-SCRIPTS" "Tier 5 Backup Size (${T5_BACKUP_SIZE}) Exceeds Disk Size (${DISK_SIZE})"
  TIER="t2"
  BACKUP_SOURCE_FILE="${RUNPATH}/backup-tier2.txt"
fi

if [ "$T2_BACKUP_SIZE" -gt "$DISK_SIZE" ]; then
  printf "%s\n" "  Tier 2 Backup Size (${T5_BACKUP_SIZE}) Exceeds Disk Size (${DISK_SIZE})"
  logger -it "BACKUP-SCRIPTS" "Tier 2 Backup Size (${T5_BACKUP_SIZE}) Exceeds Disk Size (${DISK_SIZE})"
  logger -it "BACKUP-SCRIPTS" "Local backup failed!"
  exit
fi

if [ "$TIER" == "t5" ]; then
  BACKUP_SIZE_GB=$(units -t -o "%.2f" "${T5_BACKUP_SIZE} mebibytes" 'gigabytes')
else
  BACKUP_SIZE_GB=$(units -t -o "%.2f" "${T2_BACKUP_SIZE} mebibytes" 'gigabytes')
fi

DISK_SIZE_GB=$(units -t -o "%.2f" "${DISK_SIZE} mebibytes" 'gigabytes')
printf "%-${WIDTH}s%s\n" "- Calculating Backup Size: " "[OK]"

################################################################################
# DO THE BACKUP

printf "%-${WIDTH}s" "- Starting Backup/s in Screen"
logger -it "BACKUP-SCRIPTS" "Starting Backup/s in Screen"
echo "" > "${RUNPATH}/backup-progress"

while IFS= read -r DIR; do
  screen -dm sh -c "rsync -ah --no-inc-recursive --info=progress2 ${DIR} ${BACKUP_PATH}/ >${RUNPATH}/backup-progress"
done < "$BACKUP_SOURCE_FILE"

if screen -ls >/dev/null; then
  echo "*/15 * * * * root ${SCRIPTPATH}/local-finished.sh ${TIER}" > /etc/cron.d/backup-task
  printf "%s\n" "[OK]"

  logger -it "BACKUP-SCRIPTS" "Tier ${TIER} local backup started"
  logger -it "BACKUP-SCRIPTS" " Backup disk space: ${BACKUP_SIZE_GB} GBytes"
  logger -it "BACKUP-SCRIPTS" " Physical disk space: ${DISK_SIZE_GB} GBytes"

  exit
else
  printf "%s\n" "[FAILED]"
  logger -it "BACKUP-SCRIPTS" "Starting Backup/s in Screen: FAILED"
fi

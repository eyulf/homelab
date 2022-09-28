#!/bin/bash

################################################################################
# SETTINGS

RUNPATH='/root'
SCRIPTPATH="$RUNPATH/backup-scripts"
WIDTH='34'

BACKUP_CRYPT_NAME='backup_crypt'
BACKUP_CRYPT_DEVICE="/dev/mapper/${BACKUP_CRYPT_NAME}"
BACKUP_PATH='/backup'

case $1 in
  't2')
    TIER=2
    ;;
  't5')
    TIER=3
    ;;
  *)
    printf "%s\n" "Backup type not selected!" "Must be one of [t2, t5]"
    exit 1
    ;;
esac

BACKUP_SOURCE_FILE="${RUNPATH}/backup-tier${TIER}.txt"
BACKUP_SIZE=0
BACKUP_COUNT=0

################################################################################
# SANITY CHECKS

#######################################
# Backup Running

printf "%-${WIDTH}s" "- Checking for existing backups: "

if /usr/bin/screen -ls >/dev/null; then
  printf "%s\n" "[Failed]"
  printf "\n%s\n" "Backup Already Running!"
  printf "%s\n" "$(cat "${RUNPATH}/backup-progress")"
  exit
else
  printf "%s\n" "[OK]"
fi

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
  logger -it "BACKUP-SCRIPTS" "Tier ${1} backup failed!"
  logger -it "BACKUP-SCRIPTS" "Backup Disk not found"
  exit
elif (( $(grep -c . <<<"$DISK") > 1 )); then
  printf "%s\n" "[FAILED]"
  printf "\n%s\n" "More then 1 Backup Disk present!"
  hwinfo --disk --short
  logger -it "BACKUP-SCRIPTS" "Tier ${1} backup failed!"
  logger -it "BACKUP-SCRIPTS" "More then 1 Backup Disk present"
  exit
else
  printf "%s\n" "[OK] (${DISK})"
fi

#######################################
# Encryption present

printf "%-${WIDTH}s" "- Checking Encryption: "

if ! cryptsetup isLuks "$DISK" >/dev/null ; then
  printf "%s\n" "[FAILED]"
  printf "\n%s\n" "Disk is not Encrypted!!!"
  logger -it "BACKUP-SCRIPTS" "Tier ${1} backup failed!"
  logger -it "BACKUP-SCRIPTS" "Disk (${DISK}) is not Encrypted"
  exit
else
  cryptsetup --key-file "${RUNPATH}/backup.pass" luksOpen "$DISK" "$BACKUP_CRYPT_NAME"
  printf "%s\n" "[OK]"
fi

#######################################
# Filesystem Mounted

printf "%-${WIDTH}s" "- Checking Filesystem: "

if ! mount | grep "$BACKUP_CRYPT_DEVICE" >/dev/null; then
  mount "$BACKUP_CRYPT_DEVICE" "$BACKUP_PATH"
fi

if ! mount | grep "$BACKUP_CRYPT_DEVICE" >/dev/null; then
  printf "%s\n" "[FAILED]"
  printf "\n%s\n" "Filesystem Not Present!!!"
  logger -it "BACKUP-SCRIPTS" "Tier ${1} backup failed!"
  logger -it "BACKUP-SCRIPTS" "Filesystem Not Present"
  exit
else
  printf "%s\n" "[OK]"
fi

#######################################
# Check Backup Size

printf "%-${WIDTH}s" "- Calculating Backup Size: "

# Get Size of backups in MiB, also get file count
while IFS= read -r DIR; do
  BACKUP_SIZE=$(( BACKUP_SIZE + $(du -ms "$DIR" | awk '{print $1}') ))
  BACKUP_COUNT=$(( BACKUP_COUNT + $(find "$DIR" -print0 | tr -dc '\0' | wc -c) ))
done < "$BACKUP_SOURCE_FILE"

# Get Size of disk in MiB
DISK_SIZE=$(df -m "$BACKUP_CRYPT_DEVICE" | awk '{ if ( NR > 1  ) print $2}')

# Allow for reserved blocks/etc to prevent adversely affecting performance
DISK_SIZE=$(echo "scale=0; ${DISK_SIZE} * 0.92" | bc)
DISK_SIZE=$(printf "%.0f" "$DISK_SIZE")

if [ "$BACKUP_SIZE" -gt "$DISK_SIZE" ]; then
  printf "%s\n" "[FAILED]"
  printf "\n%s\n" "Backup Size Exceeds Disk Size!"
  logger -it "BACKUP-SCRIPTS" "Tier ${1} backup failed!"
  logger -it "BACKUP-SCRIPTS" "Backup Size (${BACKUP_SIZE}) Exceeds Disk Size (${DISK_SIZE})"
  exit
fi

BACKUP_SIZE_TB=$(units -t -o "%.2f" "${BACKUP_SIZE} mebibytes" 'terabytes')
DISK_SIZE_TB=$(units -t -o "%.2f" "${DISK_SIZE} mebibytes" 'terabytes')
printf "%s\n" "[OK]"

################################################################################
# DO THE BACKUP

printf "%-${WIDTH}s" "- Starting Backup/s in Screen"
echo "" > "${RUNPATH}/backup-progress"

while IFS= read -r DIR; do
  /usr/bin/screen -dm sh -c "rsync -ah --no-inc-recursive --info=progress2 ${DIR} ${BACKUP_PATH}/ >${RUNPATH}/backup-progress"
done < "$BACKUP_SOURCE_FILE"

if /usr/bin/screen -ls >/dev/null; then
  echo "*/15 * * * * root ${SCRIPTPATH}/local-finished.sh ${1}" > /etc/cron.d/backup-task
  printf "%s\n" "[OK]"

  logger -it "BACKUP-SCRIPTS" "Tier ${1} backup started"
  logger -it "BACKUP-SCRIPTS" " Backup disk space: ${BACKUP_SIZE_TB} TB"
  logger -it "BACKUP-SCRIPTS" " Physical disk space: ${DISK_SIZE_TB} TB"

  echo "**Tier ${1} backup started!**" | "${SCRIPTPATH}/notify.sh"
  echo "Backup disk space: ${BACKUP_SIZE_TB} TB" | "${SCRIPTPATH}/notify.sh"
  echo "Physical disk space: ${DISK_SIZE_TB} TB" | "${SCRIPTPATH}/notify.sh"

  exit
else
  printf "%s\n" "[FAILED]"
fi

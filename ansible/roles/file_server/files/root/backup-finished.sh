#! /bin/sh

################################################################################
# SETTINGS

WIDTH='34'
EMAIL='alex@alexgardner.id.au'

case $1 in
  'full')
    ;;
  'partial')
    ;;
  *)
    printf "%s\n" "Backup type not selected!" "Must be one of [full, partial]"
    exit 1
    ;;
esac


################################################################################
# SANITY CHECKS

#######################################
# Backup Running

printf "%-${WIDTH}s" "- Checking for existing backups: "

RUNNINGBACKUP=$(/usr/local/bin/screen -ls)

if [ $? -eq 0 ]; then
  printf "%s\n" "[Failed]"
  printf "\n%s\n" "Backup Already Running!"
  printf "%s\n" "$(cat /root/backup-progress)"
  exit
else
  printf "%s\n" "[OK]"
fi

#######################################
# Disk Present

printf "%-${WIDTH}s" "- Checking USB Disk: "

DISK=$(camcontrol devlist | grep USB)

if [ $? -ne 0 ]; then
  printf "%s\n" "[FAILED]"
  printf "\n%s\n" "USB Disk NOT FOUND!"
  exit
else
  DEVICE=$(echo "$DISK" | cut -d '(' -f 2 | cut -d ',' -f 2 | cut -d ')' -f 1)
  DISK=$(echo "$DISK" | cut -d '(' -f 2 | cut -d ',' -f 1)
  printf "%s\n" "[OK]"
fi

#######################################
# Encryption present

printf "%-${WIDTH}s" "- Checking Encryption: "

ENCRYPTION=$(geli list gpt/backup.eli)
if [ $? -eq 1 ]; then
  printf "%s\n" "[OK]"
  geli attach -k /root/backup.key -j /root/backup.pass /dev/gpt/backup
else
  printf "%s\n" "[OK]"
fi

#######################################
# Filesystem Mounted

printf "%-${WIDTH}s" "- Checking Filesystem: "

MOUNTED=$(mount | grep '/dev/gpt/backup.eli')

if [ $? -eq 1 ]; then
  printf "%s\n" "[FAILED]"
  printf "\n%s\n" "Filesystem Not Present!!!"
  exit
else
  printf "%s\n" "[OK]"
fi

#######################################
# Getting Disk Details

printf "%-${WIDTH}s" "- Getting Disk Details: "

DISK_CAPACITY=$(smartctl -a /dev/$DEVICE | grep 'User Capacity' | awk '{print $5,$6}')
DISK_MODEL=$(smartctl -a /dev/$DEVICE | grep 'Device Model' | awk '{print $3}')
DISK_SERIAL=$(smartctl -a /dev/$DEVICE | grep 'Serial Number' | awk '{print $3}')

if [ $? -eq 1 ]; then
  printf "%s\n" "[FAILED]"
  printf "\n%s\n" "Cannot Find Disk!!!"
  exit
else
  printf "%s\n" "[OK]"
fi


################################################################################
# DO THE THING

USED=$(df -h| grep '/dev/gpt/backup.eli' |awk '{print $3}')
AVAIL=$(df -h| grep '/dev/gpt/backup.eli' |awk '{print $4}')

echo ""
echo "- Unmounting Filesystem"
logger -it "BACKUP-SCRIPTS" "Unmounting filesystem"
umount /backup/
geli detach /dev/gpt/backup.eli

rm -f /etc/cron.d/backup-task
logger -it "BACKUP-SCRIPTS" "Cleaned up cron"

MESSAGE=$(cat <<-END
The $1 backup has completed!

- Used Disk Space: $USED
- Avaliable Disk Space: $AVAIL
END
)

logger -it "BACKUP-SCRIPTS" "$1 backup completed!"
logger -it "BACKUP-SCRIPTS" " Used disk space: $USED"
logger -it "BACKUP-SCRIPTS" " Avaliable disk space: $AVAIL"

echo ""
echo "$MESSAGE"
echo "$MESSAGE" | mail -s "$1 backup completed" $EMAIL

logger -it "BACKUP-SCRIPTS" "Sent Email to $EMAIL"

exit

#! /bin/sh

################################################################################
# SETTINGS

RUNPATH='/root'
WIDTH='34'

case $1 in
  'full')
    BACKUPSOURCE='/storage/data'
    ;;
  'partial')
    BACKUPSOURCE='/storage/data/secure'
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
# Missing Files

printf "%-${WIDTH}s" "- Checking for files needed: "

for FILE in /backup /root/backup.key /root/backup.pass
do
  EXISTS=$(ls -la $FILE)

  if [ $? -ne 0 ]; then
    printf "%s\n" "[FAILED]"
    exit
  fi
done

printf "%s\n" "[OK]"

#######################################
# Disk Present

printf "%-${WIDTH}s" "- Checking USB Disk: "

DISK=$(camcontrol devlist | grep USB)

if [ $? -ne 0 ]; then
  printf "%s\n" "[FAILED]"
  printf "\n%s\n" "USB Disk NOT FOUND!"
  exit
else
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
  mount /dev/gpt/backup.eli /backup/
fi

MOUNTED=$(mount | grep '/dev/gpt/backup.eli')

if [ $? -eq 1 ]; then
  printf "%s\n" "[FAILED]"
  printf "\n%s\n" "Filesystem Not Present!!!"
  exit
else
  printf "%s\n" "[OK]"
fi

#######################################
# Check Backup Size

printf "%-${WIDTH}s" "- Calculating Backup Size: "

USED=$(df | grep $BACKUPSOURCE |awk '{print $3}')
DISK=$(df | grep '/dev/gpt/backup.eli' |awk '{print $2}')
TOTAL=0
for SIZE in $USED; do
  TOTAL=$(expr $TOTAL + $SIZE)
done

if [ $TOTAL -gt $DISK ]; then
  printf "%s\n" "[FAILED]"
  printf "\n%s\n" "Backup Size Exceeds Disk Size!"
  exit
fi

HUMANTOTAL=$(units -t -o "%.2f" "$TOTAL kilobytes" 'terabytes')
printf "%s\n" "[OK]"

################################################################################
# DO THE BACKUP

printf "%-${WIDTH}s" "- Starting Backup in Screen"
echo "" > /root/backup-progress
/usr/local/bin/screen -dm sh -c "rsync -ah --no-inc-recursive --info=progress2 $BACKUPSOURCE /backup/ >/root/backup-progress"

RUNNINGBACKUP=$(/usr/local/bin/screen -ls)

USED=$(df -h | grep $BACKUPSOURCE |awk '{print $3}')
DISK=$(df -h | grep '/dev/gpt/backup.eli' |awk '{print $2}')

if [ $? -eq 0 ]; then
  echo "*/30 * * * * root $RUNPATH/backup-finished.sh $1" > /etc/cron.d/backup-task
  printf "%s\n" "[OK]"
  logger -it "BACKUP-SCRIPTS" "$1 backup started"
  logger -it "BACKUP-SCRIPTS" " Backup disk space: $DISK"
  logger -it "BACKUP-SCRIPTS" " Used disk space: $TOTAL"

  exit
else
  printf "%s\n" "[FAILED]"
fi

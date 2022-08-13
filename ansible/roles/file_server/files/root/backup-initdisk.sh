#! /bin/sh

################################################################################
# SANITY CHECKS

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

MOUNTED=$(df -h /dev/gpt/backup.eli)

if [ $? -eq 0 ]; then
  echo ""
  echo  "- Unmounting Filesystem"
  umount /backup/
  geli detach /dev/gpt/backup.eli
fi

ENCRYPTION=$(geli list gpt/backup.eli)

if [ $? -eq 0 ]; then
  echo ""
  echo  "- Removing Encryption"
  geli kill gpt/backup.eli
fi

PARTITION=$(gpart list da0)

geli list

if [ $? -eq 0 ]; then
  echo ""
  echo  "- Removing Existing Partition"
  gpart delete -i 1 da0
  gpart destroy da0
fi

################################################################################
# DO THE THING

echo ""
echo "- Creating Partition"
gpart create -s gpt da0
gpart add -t freebsd-zfs -l backup da0

echo ""
echo "- Encrypting Partition"
geli init -e AES-XTS -l 256 -s 4096 -K /root/backup.key -J /root/backup.pass /dev/gpt/backup
geli attach -k /root/backup.key -j /root/backup.pass /dev/gpt/backup

echo ""
echo "- Creating Filesystem"
echo "This can take hours!"
dd if=/dev/random of=/dev/gpt/backup.eli bs=1m
newfs /dev/gpt/backup.eli

echo ""
echo  "- Mounting Filesystem"
mount /dev/gpt/backup.eli /backup/
df -h /dev/gpt/backup.eli

echo ""
echo  "- Unmounting Filesystem"
umount /backup/
geli detach /dev/gpt/backup.eli

echo ""
echo "DISK IS READY FOR BACKUPS"

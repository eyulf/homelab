#!/bin/bash

DATE=$(date +"%Y-%m-%d")

TIER="1"
RCLONE_SRC="zfs-storage"
RCLONE_DEST="aws-s3-enc"
COMMON_DIR="/storage/data/secure"

printf "Backup Tier: %s\n" "${TIER}"
printf " - Date: %s\n" "${DATE}"

logger -it "BACKUP-SCRIPTS" "Tier ${TIER} ${RCLONE_DEST} backup started"
echo "**Tier ${TIER} ${RCLONE_DEST} backup started**" | $SCRIPTPATH/notify.sh

while IFS= read -r DIR; do
  DEST_DIR=${DIR#"$COMMON_DIR"}
  printf "Running Command: rclone copy ${RCLONE_SRC}:%s ${RCLONE_DEST}:/%s%s\n" "${DIR}" "${DATE}" "${DEST_DIR}"
  rclone copy "${RCLONE_SRC}:${DIR}" "${RCLONE_DEST}:/${DATE}${DEST_DIR}"
done < /root/backup-tier"${TIER}".txt

SIZE=$(rclone size ${RCLONE_DEST}:/${DATE})

logger -it "BACKUP-SCRIPTS" "Tier ${TIER} ${RCLONE_DEST} backup completed"
logger -it "BACKUP-SCRIPTS" "${SIZE}"
echo "**Tier ${TIER} ${RCLONE_DEST} backup completed**" | $SCRIPTPATH/notify.sh
echo "${SIZE}" | $SCRIPTPATH/notify.sh

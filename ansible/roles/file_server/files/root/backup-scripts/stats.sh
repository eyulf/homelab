#!/bin/bash

echo "" > /root/backup-stats.txt

for TIER in $(seq 5); do

  printf "Backup Tier: %s\n" "${TIER}" >> /root/backup-stats.txt

  SIZE=0
  COUNT=0

  while IFS= read -r DIR; do
    SIZE=$(( SIZE + $(du -ms "${DIR}" | awk '{print $1}') ))
    COUNT=$(( COUNT + $(find "${DIR}" -print0 | tr -dc '\0' | wc -c) ))
  done < /root/backup-tier"${TIER}".txt

  printf " - Size of Files: %s MiB\n" "${SIZE}" >> /root/backup-stats.txt
  printf " - Number of Files: %s\n\n" "${COUNT}" >> /root/backup-stats.txt

done

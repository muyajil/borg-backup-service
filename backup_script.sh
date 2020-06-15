echo "Creating new backup..."

if borg create ${BORG_OPTIONS} --stats ssh://${BORG_USER}@${BORG_HOST}:${BORG_PORT}/${BORG_REPO_PATH_ON_HOST}::${ARCHIVE_NAME}'-'$(date +'%Y-%m-%d-%H:%M') /backup_source ; then
  echo "Backup succeeded. Pruning..."
  borg prune --keep-hourly 6 --keep-daily 7 --keep-weekly 4
  echo "Backup finished."
else
  curl -X POST -H 'Content-type: application/json' --data '{"text":"There was a problem with the backup!"}' ${SLACK_WEBHOOK}
fi
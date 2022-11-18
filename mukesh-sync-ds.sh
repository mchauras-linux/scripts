#! /bin/bash

# Log file for sync
LOG_FILE=/tmp/nas_sync.log

# NAS user@ip
DESTINATION=mchauras@192.168.79.100

# Create Email body
EMAIL_BODY_FILE=/tmp/mail_body 

echo -e "Data transfer logs to DS\n			\
\nSource:\n`ifconfig`\n					\
\nDestination: $DESTINATION" > $EMAIL_BODY_FILE

# Sync with DS and save logs
rsync -avh --progress ~/nas/ $DESTINATION:/volume1/pub/mukesh/ 2>&1 > $LOG_FILE

# Send email
cat $EMAIL_BODY_FILE |					\
mailx -s "sync-ds log"					\
	-A $LOG_FILE					\
	mchauras.cron@gmail.com

# Delete Log file
rm $LOG_FILE
rm $EMAIL_BODY_FILE

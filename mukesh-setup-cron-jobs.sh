#!/bin/bash

CRON="/tmp/crontabfile"

crontab -l > $CRON
cat >>

# a. crontab -l > $tmpfile
# b. edit $tmpfile
# c. crontab $tmpfile
# d. rm $tmpfile

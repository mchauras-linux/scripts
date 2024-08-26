#!/bin/bash

# Define variables
subject="Agenda for the week"
recipient="mchauras@hotmail.com"
cc_recipients="mukeshmike9@gmail.com,mchauras.linux@gmail.com"
file_to_send="/tmp/agenda.txt"
body="Agenda for this week is:
`cat $file_to_send`
"
# Use mutt to send the email
echo "$body" | /usr/bin/mail -s "$subject" -c "$cc_recipients" -a "$file_to_send" "$to_recipient" 


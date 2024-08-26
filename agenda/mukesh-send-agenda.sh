#!/bin/bash

# Define variables
subject="Agenda for the week"
recipient="mchauras@hotmail.com"
cc_recipients="-c mukeshmike9@gmail.com -c mukesh.chaurasiya@ibm.com"
file_to_send="/tmp/agenda.txt"
body="Agenda for this week is:
`cat $file_to_send`
"
# Use mutt to send the email
#echo "$body" | /usr/bin/mailx -s "$subject" $cc_recipients -a $file_to_send $recipient
echo "$body" | /usr/bin/mailx -s "$subject" $cc_recipients $recipient


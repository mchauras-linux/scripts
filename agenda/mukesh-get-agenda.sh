#! /bin/bash

cd ~/scripts

if [[ $(git status agenda --porcelain) ]]; then
	git add agenda
	git pull --rebase
	git commit -s -m "Auto Updating Agenda"
	git push
fi

mv /tmp/agenda.txt /tmp/prev_agenda.txt
/usr/bin/emacs -batch -l ~/scripts/agenda/mukesh-export-agenda.el -e ~/.spacemacs

if ! cmp -s /tmp/agenda.txt /tmp/prev_agenda.txt; then
	# Send email
	echo "Agenda has changed"
	~/scripts/agenda/mukesh-send-agenda.sh
fi

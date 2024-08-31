#! /bin/bash

AGENDA_FILE="~/.agenda.html"
TEMP_AGENDA_FILE="~/.agenda_temp.html"

cd ~/scripts

if [[ $(git status agenda --porcelain) ]]; then
	git add agenda
	git pull --rebase
	git commit -s -m "Auto Updating Agenda"
	git push
fi

mv $AGENDA_FILE $TEMP_AGENDA_FILE
#/usr/bin/emacs -batch -l ~/scripts/agenda/mukesh-export-agenda.el
emacs --eval '(progn
                 (setq org-agenda-files (list "~/scripts/agenda/agenda.org"))              
                 (org-agenda-list)
                 (org-agenda-write (expand-file-name "~/.agenda.html"))
                 (save-buffers-kill-emacs))'

if ! cmp -s $AGENDA_FILE $TEMP_AGENDA_FILE; then
	# Send email
	echo "Agenda has changed"
	#~/scripts/agenda/mukesh-send-agenda.sh
fi

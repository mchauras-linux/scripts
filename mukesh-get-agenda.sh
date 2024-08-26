#! /bin/bash

cd ~/scripts

git pull --rebase


if [[ $(git status agenda.org --porcelain) ]]; then
	git add agenda.org
	git commit -s -m "Auto Updating Agenda"
	git push
fi

mv /tmp/agenda.txt /tmp/prev_agenda.txt
/usr/bin/emacs -batch -l ~/scripts/mukesh-export-agenda.el

if ! cmp -s /tmp/agenda.txt /tmp/prev_agenda.txt; then
	# Send email
	echo "Agenda has changed"
fi

#! /bin/bash

if ! command -v git -v &> /dev/null
then
    echo "git could not be found. Install git to proceed."
    exit
fi 

if [ -d ~/scripts ]
then
	cd ~/scripts/
	git pull
else
       git clone git@github.com:mchauras-linux/scripts.git ~/scripts	
fi


